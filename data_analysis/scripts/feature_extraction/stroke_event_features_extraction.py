import pandas as pd
import math
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np


# Screen example
# +-----------+-----------+
# |           |           |
# |    Box 1  |   Box 2   |
# |           |           |
# |-----------+-----------|
# |           |           |
# |   Box 3   |   Box 4   |
# |           |           |
# +-----------+-----------+
def get_stroke_event_quadrant(x, y, max_x, max_y):
    half_screen_x = max_x / 2
    half_screen_y = max_y / 2

    if x < half_screen_x and y < half_screen_y:
        return 1  # Top-left
    elif x >= half_screen_x and y < half_screen_y:
        return 2  # Top-right
    elif x < half_screen_x and y >= half_screen_y:
        return 3  # Bottom-left
    else:
        return 4  # Bottom-right


def movement_direction(row):
    if row["Speed_X"] > 0 and row["Speed_Y"] > 0:
        return 0  # "down-right"
    elif row["Speed_X"] < 0 and row["Speed_Y"] > 0:
        return 1  # "down-left"
    elif row["Speed_X"] > 0 and row["Speed_Y"] < 0:
        return 2  # "up-right"
    elif row["Speed_X"] < 0 and row["Speed_Y"] < 0:
        return 3  # "up-left"
    else:
        return 4  # "straight"


# The table has some rows with NULL values
def preprocess_stroke_events(stroke_event_df, one_hot_encodings=False):
    max_x = math.ceil(stroke_event_df[["Start_X", "End_X"]].max().max() / 1000) * 1000
    max_y = math.ceil(stroke_event_df[['Start_Y', "End_Y"]].max().max() / 1000) * 1000

    stroke_event_df["Start_Quadrant"] = stroke_event_df.apply(
        lambda row: get_stroke_event_quadrant(row["Start_X"], row["Start_Y"], max_x, max_y), axis=1
    )

    stroke_event_df["End_Quadrant"] = stroke_event_df.apply(
        lambda row: get_stroke_event_quadrant(row["End_X"], row["End_Y"], max_x, max_y), axis=1
    )

    stroke_event_df["Direction"] = stroke_event_df.apply(movement_direction, axis=1)

    # Magnitude = sqrt(Speed_X^2 + Speed_Y^2)
    stroke_event_df["Magnitude_Speed"] = np.sqrt(stroke_event_df["Speed_X"] ** 2 + stroke_event_df["Speed_Y"] ** 2)

    # Stroke length = sqrt((End_X - Start_X)² + (End_Y - Start_Y)²)
    stroke_event_df["Stroke_Length"] = np.sqrt((stroke_event_df["End_X"] - stroke_event_df["Start_X"]) ** 2 + (
            stroke_event_df["End_Y"] - stroke_event_df["Start_Y"]) ** 2)

    # Stroke angle = atan2(End_Y - Start_Y, End_X - Start_X)
    stroke_event_df["Stroke_Angle"] = np.atan2(stroke_event_df["End_Y"] - stroke_event_df["Start_Y"],
                                               stroke_event_df["End_X"] - stroke_event_df["Start_X"])
    if one_hot_encodings:
        stroke_event_df = pd.get_dummies(stroke_event_df, columns=["Direction", "Start_Quadrant", "End_Quadrant"])

    stroke_event_df = stroke_event_df.dropna()

    return stroke_event_df


def show_relationship_between_speed_and_quadrant(stroke_event_df):
    print("DataFrame with Magnitude_Speed:")
    print(stroke_event_df.head())

    mean_speeds_components = stroke_event_df.groupby("Start_Quadrant")[
        ["Speed_X", "Speed_Y", "Magnitude_Speed"]].mean().reset_index()
    print("\nMean Speeds (X, Y, and Magnitude) by Start Quadrant:")
    print(mean_speeds_components)

    sns.set_theme(style="whitegrid")

    # Box Plots
    fig, axes = plt.subplots(nrows=1, ncols=3, figsize=(18, 5))

    sns.boxplot(x="Start_Quadrant", y='Speed_X', data=stroke_event_df, ax=axes[0])
    axes[0].set_title("Speed_X Distribution by Start Quadrant")
    axes[0].set_xlabel("Start Quadrant")
    axes[0].set_ylabel("Speed_X")

    sns.boxplot(x='Start_Quadrant', y='Speed_Y', data=stroke_event_df, ax=axes[1])
    axes[1].set_title('Speed_Y Distribution by Start Quadrant')
    axes[1].set_xlabel('Start Quadrant')
    axes[1].set_ylabel('Speed_Y')

    sns.boxplot(x='Start_Quadrant', y='Magnitude_Speed', data=stroke_event_df, ax=axes[2])
    axes[2].set_title('Magnitude Speed Distribution by Start Quadrant')
    axes[2].set_xlabel('Start Quadrant')
    axes[2].set_ylabel('Magnitude Speed')

    plt.tight_layout()
    plt.show()

    # Violin Plots
    fig, axes = plt.subplots(1, 3, figsize=(18, 5))

    sns.violinplot(x='Start_Quadrant', y='Speed_X', data=stroke_event_df, ax=axes[0])
    axes[0].set_title('Speed_X Distribution by Start Quadrant')
    axes[0].set_xlabel('Start Quadrant')
    axes[0].set_ylabel('Speed_X')

    sns.violinplot(x='Start_Quadrant', y='Speed_Y', data=stroke_event_df, ax=axes[1])
    axes[1].set_title('Speed_Y Distribution by Start Quadrant')
    axes[1].set_xlabel('Start Quadrant')
    axes[1].set_ylabel('Speed_Y')

    sns.violinplot(x='Start_Quadrant', y='Magnitude_Speed', data=stroke_event_df, ax=axes[2])
    axes[2].set_title('Magnitude Speed Distribution by Start Quadrant')
    axes[2].set_xlabel('Start Quadrant')
    axes[2].set_ylabel('Magnitude Speed')

    plt.tight_layout()
    plt.show()


def extract_stroke_event_features(stroke_event_df):
    features = []

    one_hot_encodings = False
    show_relationships = False
    stroke_event_df = preprocess_stroke_events(stroke_event_df, one_hot_encodings)

    if not one_hot_encodings and show_relationships:
        show_relationship_between_speed_and_quadrant(stroke_event_df)

    for activity_id, stroke_event_df_grouped in stroke_event_df.groupby("ActivityID"):
        stroke_event_df_grouped = stroke_event_df_grouped.sort_values(
            by=["Systime", "Begin_time"]).reset_index(drop=True)

        i = 0
        while i < len(stroke_event_df_grouped):
            stroke_event_start_row = stroke_event_df_grouped.iloc[i]

            # ActivityID is composed as SubjectID (6 digits) + Session_number (between 01 and 24) + ContentID + Run-time determined Counter value
            stroke_event_features = {"activity_id": activity_id, "user_id": int(str(activity_id)[:6]),
                                     "session_number": int(str(activity_id)[6:8]),
                                     "start_timestamps": stroke_event_df_grouped.iloc[0]["Systime"],
                                     "down_up_duration_ms": (stroke_event_start_row["End_time"] -
                                                             stroke_event_start_row["Begin_time"]),
                                     "down_down_duration_ms": stroke_event_start_row["Begin_time"],
                                     "up_down_duration_ms": stroke_event_start_row["End_time"],
                                     "start_x": stroke_event_start_row["Start_X"],
                                     "start_y": stroke_event_start_row["Start_Y"],
                                     "end_x": stroke_event_start_row["End_X"],
                                     "end_y": stroke_event_start_row["End_Y"],
                                     "X_coord_distance": stroke_event_start_row["End_X"] - stroke_event_start_row[
                                         "Start_X"],
                                     "Y_coord_distance": stroke_event_start_row["End_Y"] - stroke_event_start_row[
                                         "Start_Y"],
                                    "start_size": stroke_event_start_row["Start_size"],
                                     "end_size": stroke_event_start_row["End_size"],
                                     "avg_size": (stroke_event_start_row["Start_size"] + stroke_event_start_row[
                                         "End_size"]) / 2,
                                     "speed_x": stroke_event_start_row["Speed_X"],
                                     "speed_y": stroke_event_start_row["Speed_Y"],
                                     "magnitude_speed": stroke_event_start_row["Magnitude_Speed"],
                                     "stroke_length": stroke_event_start_row["Stroke_Length"],
                                     "stroke_angle": stroke_event_start_row["Stroke_Angle"],
                                     "phone_orientation": stroke_event_start_row["Phone_orientation"]
                                     }
            if one_hot_encodings:
                stroke_event_features["start_quadrant_0"] = stroke_event_start_row["Start_Quadrant_1"]
                stroke_event_features["start_quadrant_1"] = stroke_event_start_row["Start_Quadrant_2"]
                stroke_event_features["start_quadrant_2"] = stroke_event_start_row["Start_Quadrant_3"]
                stroke_event_features["start_quadrant_3"] = stroke_event_start_row["Start_Quadrant_4"]
                stroke_event_features["end_quadrant_0"] = stroke_event_start_row["End_Quadrant_1"]
                stroke_event_features["end_quadrant_1"] = stroke_event_start_row["End_Quadrant_2"]
                stroke_event_features["end_quadrant_2"] = stroke_event_start_row["End_Quadrant_3"]
                stroke_event_features["end_quadrant_3"] = stroke_event_start_row["End_Quadrant_4"]
                stroke_event_features["direction_0"] = stroke_event_start_row["Direction_1"]
                stroke_event_features["direction_1"] = stroke_event_start_row["Direction_2"]
                stroke_event_features["direction_2"] = stroke_event_start_row["Direction_3"]
                stroke_event_features["direction_3"] = stroke_event_start_row["Direction_4"]
            else:
                stroke_event_features["start_quadrant"] = stroke_event_start_row["Start_Quadrant"]
                stroke_event_features["end_quadrant"] = stroke_event_start_row["End_Quadrant"]
                stroke_event_features["direction"] = stroke_event_start_row["Direction"]

            if i + 1 >= len(stroke_event_df_grouped):
                if len(features) > 0:
                    stroke_event_features["down_down_duration_ms"] = features[-1]["down_down_duration_ms"]
                    stroke_event_features["up_down_duration_ms"] = features[-1]["up_down_duration_ms"]
                else:
                    stroke_event_features["down_down_duration_ms"] = stroke_event_features["down_up_duration_ms"]
                    stroke_event_features["up_down_duration_ms"] = stroke_event_features["down_up_duration_ms"]
            else:
                next_row = stroke_event_df_grouped.iloc[i + 1]

                stroke_event_features["down_down_duration_ms"] -= next_row["Begin_time"]
                stroke_event_features["down_down_duration_ms"] = abs(
                    stroke_event_features["down_down_duration_ms"])

                stroke_event_features["up_down_duration_ms"] -= next_row["Begin_time"]
                stroke_event_features["up_down_duration_ms"] = abs(stroke_event_features["up_down_duration_ms"])

            i += 1

            features.append(stroke_event_features)

    return pd.DataFrame(features)
