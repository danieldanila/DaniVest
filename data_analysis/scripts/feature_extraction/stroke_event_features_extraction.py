import pandas as pd
import math


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
        return 1 # Top-left
    elif x >= half_screen_x and y < half_screen_y:
        return 2 # Top-right
    elif x < half_screen_x and y >= half_screen_y:
        return 3 # Bottom-left
    else:
        return 4 # Bottom-right


def movement_direction(row):
    if row['Speed_X'] > 0 and row['Speed_Y'] > 0:
        return 0 # "down-right"
    elif row['Speed_X'] < 0 and row['Speed_Y'] > 0:
        return 1 # "down-left"
    elif row['Speed_X'] > 0 and row['Speed_Y'] < 0:
        return 2 # "up-right"
    elif row['Speed_X'] < 0 and row['Speed_Y'] < 0:
        return 3 # "up-left"
    else:
        return 4 # "straight"


# The table has some rows with NULL values
def preprocess_stroke_events(stroke_event_df):
    max_x = math.ceil(stroke_event_df[["Start_X", "End_X"]].max().max() / 1000) * 1000
    max_y = math.ceil(stroke_event_df[['Start_Y', "End_Y"]].max().max() / 1000) * 1000

    stroke_event_df["Start_Quadrant"] = stroke_event_df.apply(
        lambda row: get_stroke_event_quadrant(row["Start_X"], row["Start_Y"], max_x, max_y), axis=1
    )

    stroke_event_df["End_Quadrant"] = stroke_event_df.apply(
        lambda row: get_stroke_event_quadrant(row["End_X"], row["End_Y"], max_x, max_y), axis=1
    )

    stroke_event_df["Direction"] = stroke_event_df.apply(movement_direction, axis=1)

    stroke_event_df = pd.get_dummies(stroke_event_df, columns=["Direction", "Start_Quadrant", "End_Quadrant"])

    stroke_event_df = stroke_event_df.dropna()

    return stroke_event_df


def extract_stroke_event_features(stroke_event_df):
    features = []

    stroke_event_df = preprocess_stroke_events(stroke_event_df)

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
                                     "start_size": stroke_event_start_row["Start_size"],
                                     "end_x": stroke_event_start_row["End_X"],
                                     "end_y": stroke_event_start_row["End_Y"],
                                     "end_size": stroke_event_start_row["End_size"],
                                     "speed_x": stroke_event_start_row["Speed_X"],
                                     "speed_y": stroke_event_start_row["Speed_Y"],
                                     "phone_orientation": stroke_event_start_row["Phone_orientation"],
                                     "X_coord_distance": stroke_event_start_row["End_X"] - stroke_event_start_row[
                                         "Start_X"],
                                     "Y_coord_distance": stroke_event_start_row["End_Y"] - stroke_event_start_row[
                                         "Start_Y"],
                                     # "start_quadrant": stroke_event_start_row["Start_Quadrant"],
                                     # "end_quadrant": stroke_event_start_row["End_Quadrant"],
                                     # "direction": stroke_event_start_row["Direction"]
                                     "start_quadrant_0": stroke_event_start_row["Start_Quadrant_1"],
                                     "start_quadrant_1": stroke_event_start_row["Start_Quadrant_2"],
                                     "start_quadrant_2": stroke_event_start_row["Start_Quadrant_3"],
                                     "start_quadrant_3": stroke_event_start_row["Start_Quadrant_4"],
                                     "end_quadrant_0": stroke_event_start_row["End_Quadrant_1"],
                                     "end_quadrant_1": stroke_event_start_row["End_Quadrant_2"],
                                     "end_quadrant_2": stroke_event_start_row["End_Quadrant_3"],
                                     "end_quadrant_3": stroke_event_start_row["End_Quadrant_4"],
                                     "direction_0": stroke_event_start_row["Direction_1"],
                                     "direction_1": stroke_event_start_row["Direction_2"],
                                     "direction_2": stroke_event_start_row["Direction_3"],
                                     "direction_3": stroke_event_start_row["Direction_4"]
                                     }

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
