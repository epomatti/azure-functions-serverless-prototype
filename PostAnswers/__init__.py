import azure.functions as func
import pymongo
from ..shared_code import mongo
from ..shared_code import keyvault
import json


def main(req: func.HttpRequest) -> func.HttpResponse:
    obj = json.loads(s=req.get_body(), encoding="UTF-8")

    # encrypt
    safe_email = keyvault.encrypt(obj["email"])
    print(safe_email)
    plain_email = keyvault.decrypt(safe_email)
    print(plain_email)
    # send to mongo
    return func.HttpResponse(f"Hello!")