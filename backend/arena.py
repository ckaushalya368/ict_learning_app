from datetime import datetime, timedelta, timezone
from random import SystemRandom
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Path
from firebase_admin import firestore
from pydantic import BaseModel, ConfigDict, Field, StrictInt

from auth import get_current_user
from firebase_setup import get_database
from questions import QUESTIONS

router = APIRouter(prefix="/arena", tags=["Group Arena"])

RoomCode = Annotated[str, Path(pattern=r"^\d{6}$")]
CurrentUser = Annotated[dict, Depends(get_current_user)]

QUESTION_COUNT = 3
QUIZ_SECONDS = 180


class QuizSubmission(BaseModel):
    model_config = ConfigDict(extra="forbid")

    answers: dict[str, StrictInt] = Field(
        default_factory=dict,
        max_length=QUESTION_COUNT,
    )


def calculate_score(question_ids, answers):
    return sum(
        1
        for question_id in question_ids
        if answers.get(question_id) == QUESTIONS[question_id]["answer"]
    )


def validate_answers(question_ids, answers):
    if not set(answers).issubset(set(question_ids)):
        raise HTTPException(400, "Answer only your assigned questions.")

    for question_id, selected in answers.items():
        if selected < 0 or selected >= len(QUESTIONS[question_id]["options"]):
            raise HTTPException(400, f"Invalid option for {question_id}.")


@router.post("/{room_code}/start")
def start_quiz(room_code: RoomCode, user: CurrentUser):
    db = get_database()
    room_ref = db.collection("rooms").document(room_code)

    @firestore.transactional
    def start(transaction):
        snapshot = room_ref.get(transaction=transaction)

        if not snapshot.exists:
            raise HTTPException(404, "Room not found.")

        room = snapshot.to_dict()

        if room["hostId"] != user["uid"]:
            raise HTTPException(403, "Only the host can start the quiz.")

        if room["status"] != "waiting":
            raise HTTPException(409, "Room is not waiting for a quiz.")

        players = list(
            room_ref.collection("players").stream(transaction=transaction)
        )
        player_ids = [player.id for player in players]

        if user["uid"] not in player_ids:
            raise HTTPException(403, "Host must be a room member.")

        if not 2 <= len(players) <= 20:
            raise HTTPException(400, "A quiz requires 2 to 20 players.")

        now = datetime.now(timezone.utc)
        deadline = now + timedelta(seconds=QUIZ_SECONDS)
        random = SystemRandom()

        for player in players:
            transaction.set(
                room_ref.collection("assignments").document(player.id),
                {
                    "questionIds": random.sample(
                        list(QUESTIONS), QUESTION_COUNT
                    ),
                    "answers": {},
                    "submitted": False,
                },
            )

        transaction.update(
            room_ref,
            {
                "status": "playing",
                "startedAt": now,
                "deadline": deadline,
                "participantIds": player_ids,
                "questionCount": QUESTION_COUNT,
            },
        )

        return {
            "status": "playing",
            "roomCode": room_code,
            "playerCount": len(players),
            "questionCount": QUESTION_COUNT,
            "deadline": deadline.isoformat(),
        }

    return start(db.transaction())


def quiz_session(room_code, uid, action="read", answers=None):
    db = get_database()
    room_ref = db.collection("rooms").document(room_code)

    @firestore.transactional
    def process(transaction):
        snapshot = room_ref.get(transaction=transaction)

        if not snapshot.exists:
            raise HTTPException(404, "Room not found.")

        room = snapshot.to_dict()
        participant_ids = room.get("participantIds", [])

        if uid not in participant_ids:
            raise HTTPException(403, "You are not a quiz participant.")

        if room["status"] not in ("playing", "finished"):
            raise HTTPException(409, "Quiz is not running.")

        snapshots = list(
            room_ref.collection("assignments").stream(
                transaction=transaction
            )
        )

        records = {
            item.id: item.to_dict()
            for item in snapshots
            if item.id in participant_ids
        }
        references = {
            item.id: item.reference
            for item in snapshots
            if item.id in participant_ids
        }

        if set(records) != set(participant_ids):
            raise HTTPException(503, "Quiz assignments are incomplete.")

        now = datetime.now(timezone.utc)
        deadline = room.get("deadline")

        # Support rooms started before this update.
        if deadline is None:
            deadline = room["startedAt"] + timedelta(seconds=QUIZ_SECONDS)

        own = records[uid]
        already_submitted = own.get("submitted", False)

        if room["status"] == "playing":
            if now >= deadline:
                # Late answers are not accepted.
                # Score only answers already saved before the deadline.
                for player_id, record in records.items():
                    if record.get("submitted"):
                        continue

                    saved_answers = record.get("answers", {})
                    result = {
                        "score": calculate_score(
                            record["questionIds"], saved_answers
                        ),
                        "submitted": True,
                        "timedOut": True,
                        "submittedAt": firestore.SERVER_TIMESTAMP,
                    }

                    transaction.update(references[player_id], result)
                    record.update(result)

                transaction.update(
                    room_ref,
                    {
                        "status": "finished",
                        "finishedAt": firestore.SERVER_TIMESTAMP,
                    },
                )
                room["status"] = "finished"

            elif action in ("save", "submit") and not already_submitted:
                selected_answers = answers if answers is not None else {}

                validate_answers(
                    own["questionIds"],
                    selected_answers,
                )

                update = {"answers": selected_answers}

                if action == "submit":
                    update.update(
                        {
                            "score": calculate_score(
                                own["questionIds"],
                                selected_answers,
                            ),
                            "submitted": True,
                            "timedOut": False,
                            "submittedAt": firestore.SERVER_TIMESTAMP,
                        }
                    )

                transaction.update(references[uid], update)
                own.update(update)

                if all(
                    record.get("submitted", False)
                    for record in records.values()
                ):
                    transaction.update(
                        room_ref,
                        {
                            "status": "finished",
                            "finishedAt": firestore.SERVER_TIMESTAMP,
                        },
                    )
                    room["status"] = "finished"

        return {
            "roomCode": room_code,
            "status": room["status"],
            "deadline": deadline.isoformat(),
            "remainingMs": max(
                0,
                int((deadline - now).total_seconds() * 1000),
            ),
            "submitted": own.get("submitted", False),
            "score": own.get("score"),
            "total": len(own["questionIds"]),
            "alreadySubmitted": already_submitted,
            "answers": own.get("answers", {}),
            "questions": [
                {
                    "id": question_id,
                    "question": QUESTIONS[question_id]["question"],
                    "options": QUESTIONS[question_id]["options"],
                }
                for question_id in own["questionIds"]
            ],
        }

    return process(db.transaction())


@router.get("/{room_code}/questions")
def get_player_questions(room_code: RoomCode, user: CurrentUser):
    return quiz_session(room_code, user["uid"])


@router.post("/{room_code}/answers")
def save_answers(
    room_code: RoomCode,
    submission: QuizSubmission,
    user: CurrentUser,
):
    return quiz_session(
        room_code,
        user["uid"],
        action="save",
        answers=submission.answers,
    )


@router.post("/{room_code}/submit")
def submit_answers(
    room_code: RoomCode,
    submission: QuizSubmission,
    user: CurrentUser,
):
    return quiz_session(
        room_code,
        user["uid"],
        action="submit",
        answers=submission.answers,
    )


@router.get("/{room_code}/leaderboard")
def get_leaderboard(room_code: RoomCode, user: CurrentUser):
    session = quiz_session(room_code, user["uid"])

    if session["status"] != "finished":
        raise HTTPException(409, "Waiting for all players to submit.")

    db = get_database()
    room_ref = db.collection("rooms").document(room_code)
    room = room_ref.get().to_dict()

    names = {
        player.id: player.to_dict()["name"]
        for player in room_ref.collection("players").stream()
    }

    rows = [
        {
            "uid": assignment.id,
            "name": names.get(assignment.id, "Player"),
            "score": assignment.to_dict()["score"],
            "timedOut": assignment.to_dict().get("timedOut", False),
        }
        for assignment in room_ref.collection("assignments").stream()
        if assignment.id in room["participantIds"]
    ]

    rows.sort(key=lambda item: (-item["score"], item["name"].lower()))
    top_score = max((item["score"] for item in rows), default=0)

    for item in rows:
        item["isLegend"] = item["score"] == top_score

    return {
        "total": room["questionCount"],
        "players": rows,
    }