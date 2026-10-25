import logging
from typing import Annotated

from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from arena import router as arena_router
from auth import get_current_user
from firebase_setup import get_database

logger = logging.getLogger(__name__)

app = FastAPI(
    title="ICT Learning App API",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://ict-learning-app-6e03f.web.app",
        "https://ict-learning-app-6e03f.firebaseapp.com",
    ],
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1)(:\d+)?",
    allow_credentials=False,
    allow_methods=["GET", "POST"],
    allow_headers=["Authorization", "Content-Type"],
)


@app.get("/health")
def health_check():
    return {"status": "ok"}


@app.get("/health/firebase")
def firebase_health_check():
    try:
        db = get_database()
        db.collection("_health").document("connection").get(timeout=10)
        return {"status": "ok", "firebase": "connected"}
    except Exception:
        logger.exception("Firebase connection check failed")
        raise HTTPException(
            status_code=503,
            detail="Firebase connection failed.",
        ) from None


@app.get("/auth/me")
def current_player(
    user: Annotated[dict, Depends(get_current_user)],
):
    return {
        "uid": user["uid"],
        "provider": user.get("firebase", {}).get("sign_in_provider"),
    }


app.include_router(arena_router)