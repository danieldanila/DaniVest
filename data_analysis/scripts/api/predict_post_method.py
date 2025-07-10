from fastapi import HTTPException
import pandas as pd
from typing import List


def predict_post_method(app, data_class, data_class_name, data_model, data_scaler=None):
    @app.post(f"/predict/{data_class_name}")
    def predict(data: data_class):
        try:
            input_df = pd.DataFrame([data.model_dump()])
            input_df = input_df.drop(columns=["activity_id", "user_id", "session_number", "start_timestamps"])

            # Random Forest classifier doesn't have a scaler for example
            if data_scaler:
                input_df = data_scaler.transform(input_df)

            prediction = data_model.predict(input_df)

            if hasattr(data_model, "predict_proba"):
                probabilities = data_model.predict_proba(input_df)
                confidence_scores = probabilities.max(axis=1)
            else:
                probabilities = None
                confidence_scores = None

            return {"prediction": prediction.tolist(),
                    "probabilities": probabilities.tolist() if probabilities is not None else None,
                    "confidence": confidence_scores.tolist() if confidence_scores is not None else None}
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))

    @app.post(f"/predict/{data_class_name}/batch")
    def predict_batch(data_list: List[data_class]):
        try:
            input_df = pd.DataFrame([item.model_dump() for item in data_list])
            input_df = input_df.drop(columns=["activity_id", "user_id", "session_number", "start_timestamps"])

            # Random Forest classifier doesn't have a scaler for example
            if data_scaler:
                input_df = data_scaler.transform(input_df)

            predictions = data_model.predict(input_df)

            if hasattr(data_model, "predict_proba"):
                probabilities = data_model.predict_proba(input_df)
                confidence_scores = probabilities.max(axis=1)
            else:
                probabilities = None
                confidence_scores = None

            return {"prediction": predictions.tolist(),
                    "probabilities": probabilities.tolist() if probabilities is not None else None,
                    "confidence": confidence_scores.tolist() if confidence_scores is not None else None}
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))
