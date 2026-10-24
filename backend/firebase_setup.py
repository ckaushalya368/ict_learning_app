from pathlib import Path

import firebase_admin
from firebase_admin import credentials, firestore


def get_database():
    try:
        app = firebase_admin.get_app()
    except ValueError:
        key_path = Path(__file__).parent / "service-account.json"
        credential = credentials.Certificate(str(key_path))
        app = firebase_admin.initialize_app(credential)

    return firestore.client(app=app)