import pandas as pd


def get_properties_weights(csv_file_path):
    df = pd.read_csv(csv_file_path)

    avg_importance = df.drop(columns=["answer_time"]).mean()

    normalized_weights = (avg_importance / avg_importance.sum()) * 100
    normalized_weights = normalized_weights.round(2)

    return normalized_weights