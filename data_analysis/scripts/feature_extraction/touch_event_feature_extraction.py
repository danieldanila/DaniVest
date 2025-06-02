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

    return touch_event_df


def extract_touch_event_features(touch_event_df):
    features = []

    touch_event_df = preprocess_touch_events(touch_event_df)

    for activity_id, touch_events_df_grouped in touch_event_df.groupby("ActivityID"):
        touch_events_df_grouped = touch_events_df_grouped.sort_values(by="EventTime").reset_index(drop=True)

        i = 0
        while i < len(touch_events_df_grouped):
            start_touch_event_row = touch_events_df_grouped.iloc[i]

            # ActivityID is composed as SubjectID (6 digits) + Session_number (between 01 and 24) + ContentID + Run-time determined Counter value
            touch_event_features = {"activity_id": activity_id,
                                    "user_id": int(str(activity_id)[:6]), "session_number": int(str(activity_id)[6:8]),
                                    "start_timestamps": 0, "scenario": 0, "duration_ms": 0,
                                    "move_actions_first": 0, "move_actions_second": 0,
                                    "X_coord_first_avg": 0, "Y_coord_first_avg": 0,
                                    "X_coord_second_avg": 0, "Y_coord_second_avg": 0,
                                    "Contact_size_first_avg": 0, "Contact_size_second_avg": 0,
                                    "Phone_orientation_avg": 0
                                    }

            if start_touch_event_row["Action"] == "DOWN":
                touch_event_features["start_timestamps"] = start_touch_event_row["Systime"]
                touch_event_features["scenario"] = start_touch_event_row["Pointer_count"]
                touch_event_features["duration_ms"] = start_touch_event_row["EventTime"]
                touch_event_features["X_coord_first_avg"] = start_touch_event_row["X"]
                touch_event_features["Y_coord_first_avg"] = start_touch_event_row["Y"]
                touch_event_features["Contact_size_first_avg"] = start_touch_event_row["Contact_size"]
                touch_event_features["Phone_orientation_avg"] = start_touch_event_row["Phone_orientation"]

                j = i + 1
                while j < len(touch_events_df_grouped):
                    next_row = touch_events_df_grouped.iloc[j]

                    touch_event_features["Phone_orientation_avg"] += next_row["Phone_orientation"]

                    # Either exclusively one touch or first touch in a two touches scenario
                    if next_row["Pointer_count"] == 1 or (
                            next_row["Pointer_count"] == 2 and next_row["PointerID"] == 0):

                        touch_event_features["X_coord_first_avg"] += next_row["X"]
                        touch_event_features["Y_coord_first_avg"] += next_row["Y"]
                        touch_event_features["Contact_size_first_avg"] += next_row["Contact_size"]

                        if next_row["Action"] == "MOVE":
                            touch_event_features["move_actions_first"] += 1
                    # Second touch in a two touches scenario
                    else:
                        # Current touch event is a two touches scenario
                        touch_event_features["scenario"] = next_row["Pointer_count"]

                        touch_event_features["X_coord_second_avg"] += next_row["X"]
                        touch_event_features["Y_coord_second_avg"] += next_row["Y"]
                        touch_event_features["Contact_size_second_avg"] += next_row["Contact_size"]

                        if next_row["Action"] == "MOVE":
                            touch_event_features["move_actions_second"] += 1

                    # The touch event end for first touch (the final event in sequence)
                    # PointerID can be either 0 or 1 (1 - second touch, it was found in the dataset, probably a bug but the case is handled in code also)
                    if next_row["Pointer_count"] == 1 and next_row["Action"] == "UP":
                        touch_event_features["duration_ms"] -= next_row["EventTime"]
                        touch_event_features["duration_ms"] = abs(touch_event_features["duration_ms"])

                        touch_event_features["Phone_orientation_avg"] /= (j - i + 1)

                        # There are 'move_actions_first' samples of data + 2 (if Pointer_count/scenario = 1, one DOWN and one UP event) or + 6 if (Pointer_count/scenario = 2, three DOWN events and three UP events)
                        total_down_up_actions = 2
                        if touch_event_features["scenario"] == 2:
                            total_down_up_actions = 6

                        touch_event_features["X_coord_first_avg"] /= (
                                touch_event_features["move_actions_first"] + total_down_up_actions)
                        touch_event_features["Y_coord_first_avg"] /= (
                                touch_event_features["move_actions_first"] + total_down_up_actions)
                        touch_event_features["Contact_size_first_avg"] /= (
                                touch_event_features["move_actions_first"] + total_down_up_actions)
                        touch_event_features["X_coord_second_avg"] /= (
                                touch_event_features["move_actions_second"] + total_down_up_actions)
                        touch_event_features["Y_coord_second_avg"] /= (
                                touch_event_features["move_actions_second"] + total_down_up_actions)
                        touch_event_features["Contact_size_second_avg"] /= (
                                touch_event_features["move_actions_second"] + total_down_up_actions)

                        i = j
                        break

                    j += 1

                features.append(touch_event_features)
            i += 1

    return pd.DataFrame(features)
