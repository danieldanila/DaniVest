import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler


def prepare_analysis_data(df, csv_file_path, column_name_to_predict, columns_names_to_drop_array):
    if df is None:
        df = pd.read_csv(csv_file_path)

    if "Unnamed: 0" in df.columns:
        # Drop the auto-generated index
        df = df.drop(columns=["Unnamed: 0"])

    # When read from CSV, start_timestamps type is string
    df["start_timestamps"] = pd.to_numeric(df["start_timestamps"], errors="coerce")
    df["start_timestamps"] = df["start_timestamps"].astype("int64")

    # Predicted value will be most likely user_id
    y = df[column_name_to_predict]
    X = df.drop(columns=columns_names_to_drop_array)

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    return X, y, X_train, X_test, y_train, y_test, X_scaled, X_train_scaled, X_test_scaled
