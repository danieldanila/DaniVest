import pandas as pd
import numpy as np


def get_part_of_day(hour):
    if 0 <= hour <= 5:
        return 0 # "Late_Night_Early_Morning"
    elif 6 <= hour <= 11:
        return 1 # "Morning"
    elif 12 <= hour <= 13:
        return 2 # "Noon"
    elif 14 <= hour <= 17:
        return 3 # "Afternoon"
    elif 18 <= hour <= 21:
        return 4 # "Evening"
    else: 
        return 5 # "Night"


def timestamp_to_date(data_df):
    data_df = data_df[data_df["Systime"].astype(str).str.len() == 13].copy()
    data_df["datetime"] = pd.to_datetime(data_df["Systime"], unit="ms")

    data_df["hour"] = data_df["datetime"].dt.hour
    data_df["Hour_Sin"] = np.sin(2 * np.pi * data_df["hour"] / 24)
    data_df["Hour_Cos"] = np.cos(2 * np.pi * data_df["hour"] / 24)

    data_df["day_of_week"] = data_df["datetime"].dt.dayofweek  # Monday=0, Sunday=6
    data_df["DoW_Sin"] = np.sin(2 * np.pi * data_df["day_of_week"] / 7)
    data_df["DoW_Cos"] = np.cos(2 * np.pi * data_df["day_of_week"] / 7)

    data_df["month"] = data_df["datetime"].dt.month
    data_df["Month_Sin"] = np.sin(2 * np.pi * data_df["month"] / 12)
    data_df["Month_Cos"] = np.cos(2 * np.pi * data_df["month"] / 12)

    data_df["Part_Of_Day"] = data_df["hour"].apply(get_part_of_day).astype(int)

    data_df["Is_Weekend"] = data_df["datetime"].dt.dayofweek.isin([5, 6]).astype(int)

    data_df = data_df.drop(columns=["datetime", "hour", "day_of_week", "month"])

    return data_df
