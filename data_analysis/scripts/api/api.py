import uvicorn
from fastapi import FastAPI
import joblib

from scripts.api.predict_post_method import predict_post_method
from scripts.feature_classes.KeyPressEvent import KeyPressEvent
from scripts.feature_classes.OneFingerTouchEvent import OneFingerTouchEvent
from scripts.feature_classes.ScrollEvent import ScrollEvent
from scripts.feature_classes.StrokeEvent import StrokeEvent
from scripts.feature_classes.TouchEvent import TouchEvent


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

    app = FastAPI()

    predict_post_method(app=app, data_class=KeyPressEvent, data_class_name="keypress",
                        data_model=key_press_event_svm_model, data_scaler=key_press_event_scaler)

    predict_post_method(app=app, data_class=OneFingerTouchEvent, data_class_name="onefingertouch",
                        data_model=one_finger_touch_event_rf_model, data_scaler=None)

    predict_post_method(app=app, data_class=ScrollEvent, data_class_name="scroll",
                        data_model=scroll_event_rf_model, data_scaler=None)

    predict_post_method(app=app, data_class=StrokeEvent, data_class_name="stroke",
                        data_model=stroke_event_rf_model, data_scaler=None)

    predict_post_method(app=app, data_class=TouchEvent, data_class_name="touch",
                        data_model=touch_event_rf_model, data_scaler=None)

    uvicorn.run(app, host="0.0.0.0", port=8000)


if __name__ == "__main__":
    print()
    main()
