from typing import List
from fastapi import HTTPException
import pandas as pd
import scripts.database_operations as db
import traceback

from scripts.feature_classes.basemodel_to_df import pydantic_list_to_dataframe


def init_dataframe_with_data_after_timestamp(table_name, table_header, timestamp_ms):
    with (db.get_database_connection(database_password="oracle") as connection):
        with connection.cursor() as cursor:
            result_rows = db.read_from_table_after_timestamp(cursor, table_name, timestamp_ms)
            dataframe = pd.DataFrame(result_rows, columns=table_header)

            return dataframe


def get_table_data_after_timestamp(app, table_name, table_header):
    @app.get(f"/data/extraction/{table_name}" + "/{timestamp}")
    def table_data_after_timestamp(timestamp: int):
        try:
            dataframe = init_dataframe_with_data_after_timestamp(table_name, table_header, timestamp)

            return {f"data": dataframe.to_dict(orient="records")}
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))


def feature_extraction_from_data(app, data_class, data_class_name, extract_feature_method):
    @app.post(f"/feature/extraction/{data_class_name}")
    def feature_extraction(data: List[data_class]):
        try:
            dataframe = pydantic_list_to_dataframe(data)

            feature_dataframe = extract_feature_method(dataframe)

            return {f"feature": feature_dataframe.to_dict(orient="records")}
        except Exception as e:
            tb_str = traceback.format_exc()
            raise HTTPException(status_code=500, detail=f"{str(e)}\n{tb_str}")