# Each ActivityID has multiple scrolls which are from 0 to X
#
# There are 14725 rows that have ScrollID = -1 which is a bug because according to the documentation,
# a scroll events have unique IDs starting with 0.
# To fix this bug, all rows with identical values for the (Begin_time, Start_X, Start_Y, Start_size) tuple will
# be assigned a new ScrollID starting with X + 1, where X is the current maximum ScrollID of the current Activity
#
# There is a bug where in the same ActivityID, two different scrolls have the same ScrollID value

#       Systime   BeginTime CurrentTime          ActivityID ScrollID    Start_X     Start_Y     Start_size
# 1396226208268	    6787169	    6787844	    100669011000001	       0	    307	        813	      0.021569
# 1396226208283	    6787169	    6787860	    100669011000001	       0	    307	        813	      0.021569
# 1396226208286	    6787169	    6787862	    100669011000001	       0	    307	        813	      0.021569 -> BUG/ERROR
# 1396226256066	    6835548	    6835650	    100669011000001	       0	    590	        415	      0.021569 -> BUG/ERROR
# 1396226256109	    6835548	    6835683	    100669011000001	       0	    590	        415	      0.021569
# 1396226256124	    6835548	    6835700	    100669011000001	       0	    590	        415	      0.021569
# -> This case must be handled in code

import pandas as pd
import math

from scripts.Utils.coordinates_operations import get_quadrant, get_euclidean_distance, \
    get_angle, get_movement_direction, get_magnitude_speed
from scripts.Utils.date_transformation import timestamp_to_date


def preprocess_scroll_events(scroll_event_df):
    rows_length_with_minus_one = len(scroll_event_df[scroll_event_df["ScrollID"] == -1])
    scroll_id_max_value = scroll_event_df["ScrollID"].max()
    scroll_id_index = scroll_id_max_value + 1
    i = 0
    while i < rows_length_with_minus_one:
        row = scroll_event_df.iloc[i]

        if row["ScrollID"] == -1:
            scroll_event_df.at[i, "ScrollID"] = scroll_id_index
            j = i + 1
            while j < rows_length_with_minus_one:
                next_row = scroll_event_df.iloc[j]

                if (row["BeginTime"] == next_row["BeginTime"] and row["Start_X"] == next_row["Start_X"] and
                        row["Start_Y"] == next_row["Start_Y"] and row["Start_size"] == next_row["Start_size"]):
                    scroll_event_df.at[j, "ScrollID"] = scroll_id_index
                    j += 1
                else:
                    j -= 1
                    break

            i = j
            scroll_id_index += 1
        else:
            continue

        i += 1

    scroll_event_df = timestamp_to_date(scroll_event_df)

    return scroll_event_df


def extract_scroll_event_features(scroll_event_df):
    features = []

    max_x = math.ceil(scroll_event_df[["Start_X", "Current_X"]].max().max() / 1000) * 1000
    max_y = math.ceil(scroll_event_df[["Start_Y", "Current_Y"]].max().max() / 1000) * 1000

    one_hot_encodings = False

    for activity_id, scroll_event_df_grouped in scroll_event_df.groupby("ActivityID"):
        scroll_event_df_grouped = scroll_event_df_grouped.sort_values(
            by=["ScrollID", "BeginTime", "CurrentTime", "Start_X", "Start_Y", "Start_size"]).reset_index(drop=True)

        # Sorted the dataframe by ScrollID And ActivityID so ScrollID values=-1 come first, then sorted by the unique tuple and CurrentTime
        scroll_event_df_grouped = preprocess_scroll_events(scroll_event_df_grouped)

        i = 0
        while i < len(scroll_event_df_grouped):
            scroll_event_start_row = scroll_event_df_grouped.iloc[i]

            # ActivityID is composed as SubjectID (6 digits) + Session_number (between 01 and 24) + ContentID + Run-time determined Counter value
            scroll_event_features = {"activity_id": activity_id,
                                     "user_id": int(str(activity_id)[:6]),
                                     "session_number": int(str(activity_id)[6:8]),
                                     "start_timestamps": scroll_event_start_row["Systime"],
                                     "hour_sin": scroll_event_start_row["Hour_Sin"],
                                     "hour_cos": scroll_event_start_row["Hour_Cos"],
                                     "dow_sin": scroll_event_start_row["DoW_Sin"],
                                     "dow_cos": scroll_event_start_row["DoW_Cos"],
                                     "month_sin": scroll_event_start_row["Month_Sin"],
                                     "month_cos": scroll_event_start_row["Month_Cos"],
                                     "is_weekend": scroll_event_start_row["Is_Weekend"],
                                     "part_of_day": scroll_event_start_row["Part_Of_Day"],
                                     "scroll_id": scroll_event_start_row["ScrollID"],
                                     "down_up_duration_ms": (scroll_event_start_row["CurrentTime"] -
                                                             scroll_event_start_row["BeginTime"]),
                                     "down_down_duration_ms": scroll_event_start_row["BeginTime"],
                                     "up_down_duration_ms": scroll_event_start_row["CurrentTime"],
                                     "start_x": scroll_event_start_row["Start_X"],
                                     "start_y": scroll_event_start_row["Start_Y"],
                                     "end_x": scroll_event_start_row["Current_X"],
                                     "end_y": scroll_event_start_row["Current_Y"],
                                     "start_quadrant": get_quadrant(scroll_event_start_row["Start_X"],
                                                                    scroll_event_start_row["Start_Y"],
                                                                    max_x, max_y),
                                     "end_quadrant": get_quadrant(scroll_event_start_row["Current_X"],
                                                                  scroll_event_start_row["Current_Y"],
                                                                  max_x,
                                                                  max_y),
                                     "scroll_length_euclidean_distance": get_euclidean_distance(
                                         scroll_event_start_row["Start_X"], scroll_event_start_row["Start_Y"],
                                         scroll_event_start_row["Current_X"], scroll_event_start_row["Current_Y"]),
                                     "scroll_angle": get_angle(scroll_event_start_row["Start_X"],
                                                               scroll_event_start_row["Start_Y"],
                                                               scroll_event_start_row["Current_X"],
                                                               scroll_event_start_row["Current_Y"]),
                                     "contact_size_avg": scroll_event_start_row["Start_size"],
                                     "distance_x_avg": scroll_event_start_row["Distance_X"],
                                     "distance_y_avg": scroll_event_start_row["Distance_Y"],
                                     "direction": get_movement_direction(scroll_event_start_row["Distance_X"],
                                                                             scroll_event_start_row["Distance_Y"]),
                                     "magnitude_speed": get_magnitude_speed(scroll_event_start_row["Distance_X"],
                                                                            scroll_event_start_row["Distance_Y"]),
                                     "phone_orientation": scroll_event_start_row["Phone_orientation"],
                                     }

            j = i + 1
            while j < len(scroll_event_df_grouped):
                scroll_event_next_row = scroll_event_df_grouped.iloc[j]

                # The second check is to fix the bug mentioned: double check to see if a different scroll session have a different ScrollID
                if (scroll_event_start_row["ScrollID"] == scroll_event_next_row["ScrollID"] and
                        scroll_event_start_row["Start_X"] == scroll_event_next_row["Start_X"]):
                    scroll_event_features["contact_size_avg"] += scroll_event_next_row["Current_size"]
                    scroll_event_features["phone_orientation"] += scroll_event_next_row["Phone_orientation"]
                    scroll_event_features["distance_x_avg"] += scroll_event_next_row["Distance_X"]
                    scroll_event_features["distance_y_avg"] += scroll_event_next_row["Distance_Y"]
                    scroll_event_features["direction"] += get_movement_direction(
                        scroll_event_next_row["Distance_X"],
                        scroll_event_next_row["Distance_Y"])

                    # The third check is to fix the bug mentioned: double check to see if a different scroll session have a different ScrollID
                    # Last iteration of the current ScrollID
                    if (j + 1 == len(scroll_event_df_grouped)
                            or scroll_event_start_row["ScrollID"] != scroll_event_df_grouped.iloc[j + 1]["ScrollID"]
                            or scroll_event_start_row["Start_X"] != scroll_event_df_grouped.iloc[j + 1]["Start_X"]):
                        scroll_event_features["end_x"] = scroll_event_next_row["Current_X"]
                        scroll_event_features["end_y"] = scroll_event_next_row["Current_Y"]

                        scroll_event_features["contact_size_avg"] /= (j - i + 1)
                        scroll_event_features["phone_orientation"] /= (j - i + 1)
                        scroll_event_features["distance_x_avg"] /= (j - i + 1)
                        scroll_event_features["distance_y_avg"] /= (j - i + 1)
                        scroll_event_features["direction"] /= (j - i + 1)
                        scroll_event_features["phone_orientation"] = round(scroll_event_features["phone_orientation"])
                        scroll_event_features["direction"] = round(scroll_event_features["direction"])

                        scroll_event_features["magnitude_speed"] = get_magnitude_speed(
                            scroll_event_features["distance_x_avg"], scroll_event_features["distance_y_avg"])

                        scroll_event_features["end_quadrant"] = get_quadrant(
                            scroll_event_next_row["Current_X"], scroll_event_next_row["Current_Y"], max_x, max_y)

                        scroll_event_features[
                            "scroll_length_euclidean_distance"] = get_euclidean_distance(
                            scroll_event_next_row["Start_X"], scroll_event_next_row["Start_Y"],
                            scroll_event_next_row["Current_X"], scroll_event_next_row["Current_Y"])

                        scroll_event_features["scroll_angle"] = get_angle(scroll_event_next_row["Start_X"],
                                                                          scroll_event_next_row["Start_Y"],
                                                                          scroll_event_next_row["Current_X"],
                                                                          scroll_event_next_row["Current_Y"])

                        scroll_event_features["down_up_duration_ms"] = scroll_event_next_row["CurrentTime"] - \
                                                                       scroll_event_next_row["BeginTime"]

                        if j + 1 >= len(scroll_event_df_grouped):
                            if len(features) > 0:
                                scroll_event_features["down_down_duration_ms"] = features[-1]["down_down_duration_ms"]
                                scroll_event_features["up_down_duration_ms"] = features[-1]["up_down_duration_ms"]
                            else:
                                scroll_event_features["down_down_duration_ms"] = scroll_event_features[
                                    "down_up_duration_ms"]
                                scroll_event_features["up_down_duration_ms"] = scroll_event_features[
                                    "down_up_duration_ms"]
                        else:
                            next_row = scroll_event_df_grouped.iloc[j + 1]

                            scroll_event_features["down_down_duration_ms"] -= next_row["BeginTime"]
                            scroll_event_features["down_down_duration_ms"] = abs(
                                scroll_event_features["down_down_duration_ms"])

                            scroll_event_features["up_down_duration_ms"] -= next_row["BeginTime"]
                            scroll_event_features["up_down_duration_ms"] = abs(
                                scroll_event_features["up_down_duration_ms"])

                        i = j
                        break

                j += 1

            features.append(scroll_event_features)
            i += 1

    categorical_cols_to_encode = ["direction", "start_quadrant", "end_quadrant", "phone_orientation", "part_of_day"]

    features_df = pd.DataFrame(features)
    if one_hot_encodings:
        features_df = pd.get_dummies(features_df, columns=categorical_cols_to_encode, prefix_sep="_")

    return features_df
