import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler


def prepare_analysis_data(df, feature_name, csv_file_path, column_name_to_predict, columns_names_to_drop_array):
    if df is None:
        df = pd.read_csv(csv_file_path)

    if "Unnamed: 0" in df.columns:
        # Drop the auto-generated index
        df = df.drop(columns=["Unnamed: 0"])

    # When read from CSV, start_timestamps type is string
    df["start_timestamps"] = pd.to_numeric(df["start_timestamps"], errors="coerce")
    df["start_timestamps"] = df["start_timestamps"].astype("int64")

    # Predicted value will be most likely user_id
    class_counts =df[column_name_to_predict].value_counts()
    valid_classes = class_counts[class_counts >= 5].index
    df_filtered = df[df[column_name_to_predict].isin(valid_classes)]

    y = df_filtered[column_name_to_predict]
    X = df_filtered.drop(columns=columns_names_to_drop_array)

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    joblib.dump(scaler, f"..\\data\\scalers\\{feature_name}_scaler.pkl")

    return X, y, X_train, X_test, y_train, y_test, X_scaled, X_train_scaled, X_test_scaled
