# There are multiple cases identified in the dataset
#
# I. Two fingers are used and for a short period a time, only one finger is used
# A finger touches the screen, and it moves, then after the second finger is used, then both fingers move and then both fingers are released from the screen
#
# Pointer_count   PointerID       ActionID
# 1 (single-t)	0 (single-t)	0 (DOWN)
# -------------------------------------------- (Optional
# 1 (single-t)	0 (single-t)	2 (MOVE)
# 1 (single-t)	0 (single-t)	2 (MOVE)
# -------------------------------------------- Optional)
# 2 (multi-t)	0 (first-p-t)	5 (DOWN)
# 2 (multi-t)	1 (second-p-t)	5 (DOWN)
# 2 (multi-t)	0 (first-p-t)	2 (MOVE)
# 2 (multi-t)	1 (second-p-t)	2 (MOVE)
# 2 (multi-t)	0 (first-p-t)	2 (MOVE)
# 2 (multi-t)	1 (second-p-t)	2 (MOVE)
# 2 (multi-t)	0 (first-p-t)	2 (MOVE)
# 2 (multi-t)	1 (second-p-t)	2 (MOVE)
# -------------------------------------------- 1. (Either
# 2 (multi-t)	0 (first-p-t)	2 (MOVE)
# -------------------------------------------- 1. Or)
# 2 (multi-t)	0 (first-p-t)	6 (UP) -> The touch event pseudo-end for first touch
# 2 (multi-t)	1 (second-p-t)	6 (UP) -> The touch event end for second touch
# -------------------------------------------- 2. (Either
# 1 (single-t)	0 (single-t)	2 (MOVE)
# 1 (single-t)	0 (second-p-t)	1 (UP) -> The touch event end for first touch (the final event in sequence)
# -------------------------------------------- 2. Or)
# 1 (single-t)	1 (second-p-t)	1 (UP) -> The touch event end for first touch (the final event in sequence)
#
#
# II. A single finger is used
#
# Pointer_count   PointerID       ActionID
# 1 (single-t)	0 (single-t)	0 (DOWN)
# 1 (single-t)	0 (single-t)	2 (MOVE)
# 1 (single-t)	0 (single-t)	2 (MOVE)
# 1 (single-t)	0 (single-t)	2 (MOVE)
# 1 (single-t)	0 (single-t)	1 (UP) -> The touch event end for first touch (the final event in sequence)
#
#
# !!! There are cases that are not necessarily logical, but definitely will take them into consideration
# !!! A final event is always represented by:
#
# 1 (single-t)	0 (single-t)	1 (UP)
# -------------------------------------------- OR
# 1 (single-t)	1 (second-p-t)	1 (UP)

import pandas as pd
import math

from scripts.Utils.coordinates_operations import get_quadrant, get_movement_direction, get_euclidean_distance, get_angle
from scripts.Utils.date_transformation import timestamp_to_date


def map_action_id(action_id):
    if action_id in [0, 5]:
        return "DOWN"
    elif action_id in [1, 6]:
        return "UP"
    elif action_id == 2:
        return "MOVE"
    else:
        return "UNKNOWN"


def preprocess_touch_events(touch_event_df):
    touch_event_df["Action"] = touch_event_df["ActionID"].apply(map_action_id)
    touch_event_df = touch_event_df.sort_values(by="Systime")

    touch_event_df = timestamp_to_date(touch_event_df)

    return touch_event_df


def extract_touch_event_features(touch_event_df):
    features = []

    touch_event_df = preprocess_touch_events(touch_event_df)

    max_x = math.ceil(touch_event_df["X"].max() / 1000) * 1000
    max_y = math.ceil(touch_event_df["Y"].max() / 1000) * 1000

    one_hot_encodings = False

    for activity_id, touch_events_df_grouped in touch_event_df.groupby("ActivityID"):
        touch_events_df_grouped = touch_events_df_grouped.sort_values(by="EventTime").reset_index(drop=True)

        i = 0
        while i < len(touch_events_df_grouped):
            start_touch_event_row = touch_events_df_grouped.iloc[i]

            # ActivityID is composed as SubjectID (6 digits) + Session_number (between 01 and 24) + ContentID + Run-time determined Counter value
            touch_event_features = {"activity_id": activity_id,
                                    "user_id": int(str(activity_id)[:6]), "session_number": int(str(activity_id)[6:8]),
                                    "start_timestamps": 0, "scenario": 0,
                                    "hour_sin": 0, "hour_cos": 0,
                                    "dow_sin": 0, "dow_cos": 0,
                                    "month_sin": 0, "month_cos": 0,
                                    "is_weekend": 0, "part_of_day": 0,
                                    "down_up_duration_ms": 0, "down_down_duration_ms": 0,
                                    "up_down_duration_ms": 0,
                                    "start_x": 0, "start_y": 0,
                                    "end_x": 0, "end_y": 0,
                                    "start_quadrant": 0, "end_quadrant": 0,
                                    "X_coord_distance": 0, "Y_coord_distance": 0,
                                    "touch_length_euclidean_distance": 0,
                                    "touch_angle": 0,
                                    "contact_size_avg": 0,
                                    "direction": 0,
                                    "move_actions_first": 0, "move_actions_second": 0,
                                    "phone_orientation": 0
                                    }

            if start_touch_event_row["Action"] == "DOWN":
                touch_event_features["start_timestamps"] = start_touch_event_row["Systime"]
                touch_event_features["hour_sin"] = start_touch_event_row["Hour_Sin"]
                touch_event_features["hour_cos"] = start_touch_event_row["Hour_Cos"]
                touch_event_features["dow_sin"] = start_touch_event_row["DoW_Sin"]
                touch_event_features["dow_cos"] = start_touch_event_row["DoW_Cos"]
                touch_event_features["month_sin"] = start_touch_event_row["Month_Sin"]
                touch_event_features["month_cos"] = start_touch_event_row["Month_Cos"]
                touch_event_features["is_weekend"] = start_touch_event_row["Is_Weekend"]
                touch_event_features["part_of_day"] = start_touch_event_row["Part_Of_Day"]
                touch_event_features["scenario"] = start_touch_event_row["Pointer_count"]
                touch_event_features["down_up_duration_ms"] = start_touch_event_row["EventTime"]
                touch_event_features["down_down_duration_ms"] = start_touch_event_row["EventTime"]
                touch_event_features["start_x"] = start_touch_event_row["X"]
                touch_event_features["start_y"] = start_touch_event_row["Y"]
                touch_event_features["start_quadrant"] = get_quadrant(start_touch_event_row["X"],
                                                                      start_touch_event_row["Y"],
                                                                      max_x, max_y)
                touch_event_features["contact_size_avg"] = start_touch_event_row["Contact_size"]
                touch_event_features["phone_orientation"] = start_touch_event_row["Phone_orientation"]

                j = i + 1
                while j < len(touch_events_df_grouped):
                    next_row = touch_events_df_grouped.iloc[j]

                    touch_event_features["phone_orientation"] += next_row["Phone_orientation"]

                    # Either exclusively one touch or first touch in a two touches scenario
                    if next_row["Pointer_count"] == 1 or (
                            next_row["Pointer_count"] == 2 and next_row["PointerID"] == 0):

                        touch_event_features["contact_size_avg"] += next_row["Contact_size"]

                        if next_row["Action"] == "MOVE":
                            touch_event_features["move_actions_first"] += 1
                    # Second touch in a two touches scenario
                    else:
                        # Current touch event is a two touches scenario
                        touch_event_features["scenario"] = next_row["Pointer_count"]

                        touch_event_features["contact_size_avg"] += next_row["Contact_size"]

                        if next_row["Action"] == "MOVE":
                            touch_event_features["move_actions_second"] += 1

                    # The touch event end for first touch (the final event in sequence)
                    # PointerID can be either 0 or 1 (1 - second touch, it was found in the dataset, probably a bug but the case is handled in code also)
                    if next_row["Pointer_count"] == 1 and next_row["Action"] == "UP":
                        touch_event_features["down_up_duration_ms"] -= next_row["EventTime"]
                        touch_event_features["down_up_duration_ms"] = abs(touch_event_features["down_up_duration_ms"])

                        touch_event_features["phone_orientation"] /= (j - i + 1)
                        touch_event_features["phone_orientation"] = round(touch_event_features["phone_orientation"])

                        touch_event_features["end_x"] = next_row["X"]
                        touch_event_features["end_y"] = next_row["Y"]
                        touch_event_features["end_quadrant"] = get_quadrant(next_row["X"],
                                                                            next_row["Y"],
                                                                            max_x, max_y)

                        touch_event_features["X_coord_distance"] = next_row["X"] - start_touch_event_row["X"]
                        touch_event_features["Y_coord_distance"] = next_row["Y"] - start_touch_event_row["Y"]
                        touch_event_features["direction"] = get_movement_direction(
                            touch_event_features["X_coord_distance"], touch_event_features["Y_coord_distance"])
                        touch_event_features[
                            "touch_length_euclidean_distance"] = get_euclidean_distance(start_touch_event_row["X"],
                                                                                        start_touch_event_row["Y"],
                                                                                        next_row["X"],
                                                                                        next_row["Y"])
                        touch_event_features["touch_angle"] = get_angle(start_touch_event_row["X"],
                                                                        start_touch_event_row["Y"],
                                                                        next_row["X"],
                                                                        next_row["Y"])

                        # There are 'move_actions_first' samples of data + 2 (if Pointer_count/scenario = 1, one DOWN and one UP event) or + 6 if (Pointer_count/scenario = 2, three DOWN events and three UP events)
                        total_down_up_actions = 2
                        if touch_event_features["scenario"] == 2:
                            total_down_up_actions = 6

                        total_move_actions = touch_event_features["move_actions_first"] + \
                                             touch_event_features["move_actions_second"]

                        touch_event_features["contact_size_avg"] = touch_event_features["contact_size_avg"] / (
                                total_move_actions + total_down_up_actions)

                        touch_event_features["up_down_duration_ms"] = next_row["EventTime"]

                        i = j
                        break

                    j += 1

                if j + 1 >= len(touch_events_df_grouped):
                    touch_event_features["down_down_duration_ms"] = features[-1]["down_down_duration_ms"]
                    touch_event_features["up_down_duration_ms"] = features[-1]["up_down_duration_ms"]
                else:
                    next_row = touch_events_df_grouped.iloc[j + 1]
                    if next_row["Action"] == "DOWN":
                        touch_event_features["down_down_duration_ms"] -= next_row["EventTime"]
                        touch_event_features["down_down_duration_ms"] = abs(
                            touch_event_features["down_down_duration_ms"])

                        touch_event_features["up_down_duration_ms"] -= next_row["EventTime"]
                        touch_event_features["up_down_duration_ms"] = abs(touch_event_features["up_down_duration_ms"])

                features.append(touch_event_features)
            i += 1

    features_df = pd.DataFrame(features)

    categorical_cols_to_encode = ["scenario", "direction", "start_quadrant", "end_quadrant", "phone_orientation",
                                  "part_of_day"]

    if one_hot_encodings:
        features_df = pd.get_dummies(features_df, columns=categorical_cols_to_encode, prefix_sep="_")

    return features_df
