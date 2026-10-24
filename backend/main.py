import logging

from fastapi import FastAPI, HTTPException

from firebase_setup import get_database

logger = logging.getLogger(__name__)

app = FastAPI(
    title="ICT Learning App API",
    version="1.0.0",
)


@app.get("/health")
def health_check():
    return {"status": "ok"}


@app.get("/health/firebase")
def firebase_health_check():
    try:
        db = get_database()

        # Data වෙනස් නොකර Firestore connection එක පරීක්ෂා කරනවා.
        db.collection("_health").document("connection").get(timeout=10)

        return {
            "status": "ok",
            "firebase": "connected",
        }
    except Exception:
        logger.exception("Firebase connection check failed")
        raise HTTPException(
            status_code=503,
            detail="Firebase connection failed. Check the backend terminal.",
        ) from None