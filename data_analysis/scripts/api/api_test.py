import math

from fastapi import FastAPI
import threading
import time
import requests
from contextlib import asynccontextmanager

import data.constants as constants
import scripts.database_operations as db

latest_predictions = []
latest_timestamp = 0
lock = threading.Lock()


def get_last_timestamp():
    with db.get_database_connection(database_password="oracle") as connection:
        with connection.cursor() as cursor:
            return db.get_last_timestamp(cursor)


def update_timestamp(new_timestamp):
    with db.get_database_connection(database_password="oracle") as connection:
        with connection.cursor() as cursor:
            db.update_last_timestamp(cursor, new_timestamp)
        connection.commit()


def sanitize_for_json(data):
    if isinstance(data, float):
        if math.isnan(data) or math.isinf(data):
            return None
        return data
    elif isinstance(data, dict):
        return {k: sanitize_for_json(v) for k, v in data.items()}
    elif isinstance(data, list):
        return [sanitize_for_json(item) for item in data]
    return data


def call_api(class_name, table_name, last_timestamp):
    BASE_URL = "http://127.0.0.1:8000"

    response = requests.get(f"{BASE_URL}/data/extraction/{table_name}/{last_timestamp}")
    if response.status_code != 200:
        print(f"Error fetching data for {table_name}: {response.status_code} - {response.text}")
        return None, last_timestamp

    try:
        data = response.json()["data"]
    except Exception as e:
        print(f"Failed to parse JSON for {table_name}: {e}")
        return None, last_timestamp

    if not data:
        return None, last_timestamp

    new_last_systime = data[-1]["Systime"]

    response = requests.post(f"{BASE_URL}/feature/extraction/{class_name}", json=data)
    if response.status_code != 200:
        print(f"Error extracting features for {class_name}: {response.status_code}")
        return None, new_last_systime

    try:
        features = response.json()["feature"]
    except Exception as e:
        print(f"Failed to parse features JSON for {class_name}: {e}")
        return None, new_last_systime

    if not features:
        return None, new_last_systime

    response = requests.post(f"{BASE_URL}/predict/{class_name}/batch", json=features)
    if response.status_code != 200:
        print(f"Prediction API failed for {class_name}: {response.status_code}")
        return None, new_last_systime

    try:
        predictions = response.json()
    except Exception as e:
        print(f"Failed to parse prediction JSON for {class_name}: {e}")
        return None, new_last_systime

    return {
        "class": class_name,
        "predictions": predictions
    }, new_last_systime


def background_loop():
    global latest_predictions, latest_timestamp
    data_classes = ["touch", "keypress", "onefingertouch", "scroll", "stroke"]
    table_names = constants.relevant_tables

    while True:
        current_last_ts = get_last_timestamp()
        local_max_ts = current_last_ts
        results = []

        for i, class_name in enumerate(data_classes):
            result, new_ts = call_api(class_name, table_names[i + 1], current_last_ts)
            if result:
                results.append(result)
                if new_ts > local_max_ts:
                    local_max_ts = new_ts

        with lock:
            latest_predictions = results
            latest_timestamp = local_max_ts

        if local_max_ts > current_last_ts:
            update_timestamp(local_max_ts)

        time.sleep(3)


@asynccontextmanager
async def lifespan(app: FastAPI):
    thread = threading.Thread(target=background_loop, daemon=True)
    thread.start()
    yield


def get_latest_prediction(app):
    app.router.lifespan_context = lifespan

    @app.get("/latest-predictions")
    def get_latest_predictions():
        with lock:
            return {
                "timestamp": latest_timestamp,
                "predictions": sanitize_for_json(latest_predictions)
            }
