import os
from pathlib import Path

import firebase_admin
from firebase_admin import credentials, firestore


def get_firebase_app():
    try:
        return firebase_admin.get_app()
    except ValueError:
        local_key = Path(__file__).parent / "service-account.json"

        key_path = os.environ.get(
            "GOOGLE_APPLICATION_CREDENTIALS",
            str(local_key),
        )

        credential = credentials.Certificate(key_path)

        return firebase_admin.initialize_app(credential)


def get_database():
    return firestore.client(app=get_firebase_app())