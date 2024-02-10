import uuid

#### BEGIN imports needed for xray patching
import boto3
import botocore
import requests

#### END imports needed for xray patching
from aws_xray_sdk.core import patch_all, xray_recorder
from aws_xray_sdk.ext.flask.middleware import XRayMiddleware
from flask import Flask

app = Flask(__name__)

#### BEGIN XRay Config
plugins = ("ECSPlugin",)
xray_recorder.configure(plugins=plugins, service="App with XRay")
XRayMiddleware(app, xray_recorder)
patch_all()
#### END XRay Config

dynamodb = boto3.resource("dynamodb", region_name="us-west-2")
table = dynamodb.Table("CatFacts")


@app.route("/")
def cat_fact():
    response = requests.get("https://catfact.ninja/fact")

    cat_fact = response.json()
    fact_id = str(uuid.uuid4())

    table.put_item(
        Item={
            "FactID": fact_id,
            "Fact": cat_fact["fact"],
            "Length": cat_fact["length"],
        }
    )

    return f"<p>{cat_fact['fact']} (Length: {cat_fact['length']})</p>"
