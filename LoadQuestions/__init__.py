import os
import azure.functions as func
import pymongo
from ..shared_code import mongo
import json


def main(req: func.HttpRequest) -> func.HttpResponse:

    with open("shared_code/data.json", "r") as file:
        data = file.read()
        with mongo.get_client() as client:
            db = client.get_database("maibeer")
            collection = db.get_collection("questions")
            obj = json.loads(data)
            collection.insert_one(obj)

    return func.HttpResponse(f"Hello")