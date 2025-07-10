import uvicorn
from fastapi import FastAPI
import joblib

from scripts.api.api_test import get_latest_prediction
from scripts.api.feature_extraction import get_table_data_after_timestamp, feature_extraction_from_data
from scripts.api.predict_post_method import predict_post_method
from scripts.feature_classes.KeyPressEvent import KeyPressEvent
from scripts.feature_classes.KeyPressEventRaw import KeyPressEventRaw
from scripts.feature_classes.OneFingerTouchEvent import OneFingerTouchEvent
from scripts.feature_classes.OneFingerTouchEventRaw import OneFingerTouchEventRaw
from scripts.feature_classes.ScrollEvent import ScrollEvent
from scripts.feature_classes.ScrollEventRaw import ScrollEventRaw
from scripts.feature_classes.StrokeEvent import StrokeEvent
from scripts.feature_classes.StrokeEventRaw import StrokeEventRaw
from scripts.feature_classes.TouchEvent import TouchEvent
import data.constants as constants
from scripts.feature_classes.TouchEventRaw import TouchEventRaw
from scripts.feature_extraction.key_press_event_feature_extraction import extract_key_press_event_features
from scripts.feature_extraction.one_finger_touch_event_feature_extraction import extract_one_finger_touch_event_features
from scripts.feature_extraction.scroll_event_feature_extraction import extract_scroll_event_features
from scripts.feature_extraction.stroke_event_features_extraction import extract_stroke_event_features
from scripts.feature_extraction.touch_event_feature_extraction import extract_touch_event_features


def main():
    key_press_event_svm_model = joblib.load("..\\..\\data\\models\\key_press_event_svm_model.pkl")
    key_press_event_scaler = joblib.load("..\\..\\data\\scalers\\key_press_event_scaler.pkl")

    one_finger_touch_event_rf_model = joblib.load("..\\..\\data\\models\\one_finger_touch_event_rf_model.pkl")
    one_finger_touch_event_scaler = joblib.load("..\\..\\data\\scalers\\one_finger_touch_event_scaler.pkl")

    scroll_event_rf_model = joblib.load("..\\..\\data\\models\\scroll_event_rf_model.pkl")
    scroll_event_scaler = joblib.load("..\\..\\data\\scalers\\scroll_event_scaler.pkl")

    stroke_event_rf_model = joblib.load("..\\..\\data\\models\\stroke_event_rf_model.pkl")
    stroke_event_scaler = joblib.load("..\\..\\data\\scalers\\stroke_event_scaler.pkl")

    touch_event_rf_model = joblib.load("..\\..\\data\\models\\touch_event_rf_model.pkl")
    touch_event_scaler = joblib.load("..\\..\\data\\scalers\\touch_event_scaler.pkl")

    data_classes = [TouchEvent, KeyPressEvent, OneFingerTouchEvent, ScrollEvent, StrokeEvent]
    data_classes_names = ["touch", "keypress", "onefingertouch", "scroll", "stroke"]
    data_classes_models = [touch_event_rf_model, key_press_event_svm_model, one_finger_touch_event_rf_model, scroll_event_rf_model, stroke_event_rf_model]
    data_classes_scalers = [touch_event_scaler, key_press_event_scaler, one_finger_touch_event_scaler, scroll_event_scaler, stroke_event_scaler]

    app = FastAPI()

    for i, data_class in enumerate(data_classes):
        predict_post_method(app=app, data_class=data_class, data_class_name=data_classes_names[i],
                            data_model=data_classes_models[i], data_scaler=data_classes_scalers[i])

    table_names = constants.relevant_tables

    for i, table_name in enumerate(table_names[1:], start=1):
        get_table_data_after_timestamp(app=app, table_name=table_name, table_header=constants.table_headers[i])

    extract_classes = [TouchEventRaw, KeyPressEventRaw, OneFingerTouchEventRaw, ScrollEventRaw, StrokeEventRaw]
    extract_feature_methods= [extract_touch_event_features, extract_key_press_event_features, extract_one_finger_touch_event_features, extract_scroll_event_features, extract_stroke_event_features]
    for i, extract_class in enumerate(extract_classes):
        feature_extraction_from_data(app=app, data_class=extract_class, data_class_name=data_classes_names[i], extract_feature_method=extract_feature_methods[i])

    get_latest_prediction(app=app)

    uvicorn.run(app, host="0.0.0.0", port=8000)


if __name__ == "__main__":
    print()
    main()
