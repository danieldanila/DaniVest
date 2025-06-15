from fastapi import HTTPException
import pandas as pd

def predict_post_method(app, data_class, data_class_name,data_model, data_scaler=None):
    @app.post(f"/predict/{data_class_name}")
    def predict(data: data_class):
        try:
            input_df = pd.DataFrame([data.model_dump()])

            # Random Forest classifier doesn't have a scaler for example
            if data_scaler:
                input_df = data_scaler.transform(input_df)

            prediction = data_model.predict(input_df)

            return {"user_id_predicted": prediction.tolist()}
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))