import azure.functions as func
from ..shared_code import mongo
from ..shared_code import keyvault
from ..shared_code import hasher
import json


def main(req: func.HttpRequest) -> func.HttpResponse:
    obj = json.loads(s=req.get_body(), encoding="UTF-8")
    obj["_id"] = hasher.digest(obj["email"])
    encrypted_email = keyvault.encrypt(obj["email"])
    obj["email"] = encrypted_email
    with mongo.get_client() as client:
        db = client.get_database("maibeer")
        collection = db.get_collection("answers")
        collection.insert_one(obj)
    #plain_email = keyvault.decrypt(safe_email)
    return func.HttpResponse(f"Hello!")