from pathlib import Path

import firebase_admin
from firebase_admin import credentials, firestore


def get_firebase_app():
    try:
        return firebase_admin.get_app()
    except ValueError:
        key_path = Path(__file__).parent / "service-account.json"
        credential = credentials.Certificate(str(key_path))
        return firebase_admin.initialize_app(credential)


def get_database():
    return firestore.client(app=get_firebase_app())