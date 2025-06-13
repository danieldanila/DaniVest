import pandas as pd
import math

from scripts.Utils.coordinates_operations import get_stroke_event_quadrant, get_magnitude_speed, \
    get_euclidean_distance, get_angle, get_movement_direction
from scripts.Utils.date_transformation import timestamp_to_date
from scripts.Utils.show_relationships import show_relationship_between_speed_and_quadrant


# The table has some rows with NULL values
def preprocess_stroke_events(stroke_event_df):
    max_x = math.ceil(stroke_event_df[["Start_X", "End_X"]].max().max() / 1000) * 1000
    max_y = math.ceil(stroke_event_df[["Start_Y", "End_Y"]].max().max() / 1000) * 1000

    stroke_event_df["Start_Quadrant"] = stroke_event_df.apply(
        lambda row: get_stroke_event_quadrant(row["Start_X"], row["Start_Y"], max_x, max_y), axis=1
    )

    stroke_event_df["End_Quadrant"] = stroke_event_df.apply(
        lambda row: get_stroke_event_quadrant(row["End_X"], row["End_Y"], max_x, max_y), axis=1
    )

    stroke_event_df["Direction"] = stroke_event_df.apply(
        lambda row: get_movement_direction(row["Speed_X"], row["Speed_Y"]), axis=1)

    stroke_event_df["Magnitude_Speed"] = stroke_event_df.apply(
        lambda row: get_magnitude_speed(row["Speed_X"], row["Speed_Y"]), axis=1)

    stroke_event_df["Stroke_Length_Euclidean_Distance"] = stroke_event_df.apply(
        lambda row: get_euclidean_distance(row["Start_X"], row["Start_Y"], row["End_X"], row["End_Y"]),
        axis=1)

    stroke_event_df["Stroke_Angle"] = stroke_event_df.apply(
        lambda row: get_angle(row["Start_X"], row["Start_Y"], row["End_X"], row["End_Y"]),
        axis=1)

    stroke_event_df = timestamp_to_date(stroke_event_df)

    stroke_event_df = stroke_event_df.dropna()

    return stroke_event_df


def extract_stroke_event_features(stroke_event_df):
    features = []

    stroke_event_df = preprocess_stroke_events(stroke_event_df)

    max_x = math.ceil(stroke_event_df[["Start_X", "End_X"]].max().max() / 1000) * 1000
    max_y = math.ceil(stroke_event_df[["Start_Y", "End_Y"]].max().max() / 1000) * 1000

    one_hot_encodings = True
    show_relationships = False

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
                                     "hour_sin": stroke_event_start_row["Hour_Sin"],
                                     "hour_cos": stroke_event_start_row["Hour_Cos"],
                                     "dow_sin": stroke_event_start_row["DoW_Sin"],
                                     "dow_cos": stroke_event_start_row["DoW_Cos"],
                                     "month_sin": stroke_event_start_row["Month_Sin"],
                                     "month_cos": stroke_event_start_row["Month_Cos"],
                                     "is_weekend": stroke_event_start_row["Is_Weekend"],
                                     "part_of_day": stroke_event_start_row["Part_Of_Day"],
                                     "down_up_duration_ms": (stroke_event_start_row["End_time"] -
                                                             stroke_event_start_row["Begin_time"]),
                                     "down_down_duration_ms": stroke_event_start_row["Begin_time"],
                                     "up_down_duration_ms": stroke_event_start_row["End_time"],
                                     "start_x": stroke_event_start_row["Start_X"],
                                     "start_y": stroke_event_start_row["Start_Y"],
                                     "end_x": stroke_event_start_row["End_X"],
                                     "end_y": stroke_event_start_row["End_Y"],
                                     "start_quadrant": get_stroke_event_quadrant(stroke_event_start_row["Start_X"],
                                                                                 stroke_event_start_row["Start_Y"],
                                                                                 max_x, max_y),
                                     "end_quadrant": get_stroke_event_quadrant(stroke_event_start_row["End_X"],
                                                                               stroke_event_start_row["End_Y"],
                                                                               max_x,
                                                                               max_y),
                                     "X_coord_distance": stroke_event_start_row["End_X"] - stroke_event_start_row[
                                         "Start_X"],
                                     "Y_coord_distance": stroke_event_start_row["End_Y"] - stroke_event_start_row[
                                         "Start_Y"],
                                     "stroke_length_euclidean_distance": stroke_event_start_row[
                                         "Stroke_Length_Euclidean_Distance"],
                                     "stroke_angle": stroke_event_start_row["Stroke_Angle"],
                                     "start_size": stroke_event_start_row["Start_size"],
                                     "end_size": stroke_event_start_row["End_size"],
                                     "contact_size_avg": (stroke_event_start_row["Start_size"] + stroke_event_start_row[
                                         "End_size"]) / 2,
                                     "speed_x": stroke_event_start_row["Speed_X"],
                                     "speed_y": stroke_event_start_row["Speed_Y"],
                                     "direction": get_movement_direction(stroke_event_start_row["Speed_X"],
                                                                         stroke_event_start_row["Speed_Y"]),
                                     "magnitude_speed": stroke_event_start_row["Magnitude_Speed"],
                                     "phone_orientation": stroke_event_start_row["Phone_orientation"]
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

    categorical_cols_to_encode = ["direction", "start_quadrant", "end_quadrant", "phone_orientation", "part_of_day"]

    features_df = pd.DataFrame(features)
    if one_hot_encodings:
        features_df = pd.get_dummies(features_df, columns=categorical_cols_to_encode, prefix_sep="_")

    return features_df
