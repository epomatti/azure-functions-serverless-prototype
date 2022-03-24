import azure.functions as func
from ..shared_code import mongo
from ..shared_code import keyvault
from ..shared_code import hasher
import json

def main(req: func.HttpRequest) -> func.HttpResponse:
    participant_id = req.params.get('id')
    hash_id = hasher.digest(participant_id)
    with mongo.get_client() as client:
        db = client.get_database("myproj888")
        obj = db.answers.find_one({"_id": hash_id})
        plain_email = keyvault.decrypt(obj["email"])
    return func.HttpResponse(plain_email)