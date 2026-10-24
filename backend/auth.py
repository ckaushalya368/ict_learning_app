import logging
from typing import Annotated

from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from firebase_admin import auth
from firebase_admin.exceptions import FirebaseError

from firebase_setup import get_firebase_app

logger = logging.getLogger(__name__)
bearer = HTTPBearer(auto_error=False)


def get_current_user(
    credentials: Annotated[
        HTTPAuthorizationCredentials | None,
        Depends(bearer),
    ],
) -> dict:
    if credentials is None:
        raise HTTPException(
            status_code=401,
            detail="Login token required.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        firebase_app = get_firebase_app()
    except Exception:
        logger.exception("Firebase initialization failed")
        raise HTTPException(
            status_code=503,
            detail="Authentication service unavailable.",
        ) from None

    try:
        return auth.verify_id_token(
            credentials.credentials,
            app=firebase_app,
            check_revoked=True,
        )
    except (
        auth.InvalidIdTokenError,
        auth.RevokedIdTokenError,
        auth.UserDisabledError,
        ValueError,
    ):
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired token. Please sign in again.",
            headers={"WWW-Authenticate": "Bearer"},
        ) from None
    except FirebaseError:
        logger.exception("Firebase token verification unavailable")
        raise HTTPException(
            status_code=503,
            detail="Authentication service unavailable. Please retry.",
        ) from None