import azure.functions as func
import pymongo
from ..shared_code import mongo
from ..shared_code import keyvault
import json


def main(req: func.HttpRequest) -> func.HttpResponse:
    obj = json.loads(s=req.get_body(), encoding="UTF-8")

    # encrypt
    keyvault.encrypt(obj["email"])
    obj["_id"] = "####"
    # send to mongo
    return func.HttpResponse(f"Hello!")