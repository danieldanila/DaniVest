# Tap_Type and Action_Type columns are contradictory, for example Tap_Type of 0 means a UP event, while Action_Type
# of 0 means a DOWN event. The problem is that for each row, the values of the 2 columns are equal
# TapID     Tap_Type    Action_Type
#     0	           0	          0   -> UP and DOWN event in the same time
#     0	           1	          1   -> DOWN and UP event in the same time
#     1	           0	          0
#     1	           1	          1
#     2	           0	          0
# It is possible, that jus the documentation is wrong, so further it will be assumed that Tap_Type of 0 = DOWN in single-tap scenario,
# Tap_Type of 1 = UP and 2 & and 3 keep their original meaning from the documentation (2=DOWN in double-tap scenario
# and 3=ACTION with the second finger)
#
# For single taps with one finger, the pattern is straightforward, one down and one up event, nothing more, not even MOVE events (see example from above)
#
# For double tap scenario, the first part is similar to the single-tap scenario, one DOWN and one UP event but then,
# the second part adds additional DOWN, MOVE and UP events for the second finger (TAP_ID=3). Furthermore, for the second
# finger, the TapID is incremented
# TapID Tap_Type Action_Type      X     Y
#     7	       2	       0	956   239
#     7	       1	       1	956	  239
#     8	       3	       0	800	   93
#     8	       3	       2	800	   93
#     8	       3	       2	800	   93
#     8	       3	       1	800	   93
#
# There is a bug where a UP event does not have a DOWN event pair
# TapID Tap_Type Action_Type
#     3	       0	       0
#     3	       1	       1
#     4	       1	       1 -> BUG/ERROR
#     5	       0	       0
#     5	       1	       1
#
# There is a bug where a DOWN event does not have a UP event pair
# There is a bug where a MOVE event does not have a UP event pair
# TapID Tap_Type Action_Type
#   288	       1	       1 -> BUG/ERROR (No DOWN event pair)
#  1056	       1	       1 -> BUG/ERROR  (No DOWN event pair)
#   811	       3	       0
#   811	       3	       2 -> BUG/ERROR (No UP event followed)
#   918	       0	       0
#   543	       1	       1
#   662	       0	       0 -> BUG/ERROR (No UP event pair)
#    40	       0	       0 -> BUG/ERROR (No UP event pair)


import pandas as pd
import math

from scripts.Utils.coordinates_operations import get_quadrant, get_euclidean_distance, \
    get_movement_direction, get_angle
from scripts.Utils.date_transformation import timestamp_to_date


def map_type(tap_type, action_type):
    if tap_type == 0 and action_type == 0:
        return "FIRST_DOWN_SINGLE_TAP"
    elif tap_type == 2 and action_type == 0:
        return "FIRST_DOWN_DOUBLE_TAP"
    elif tap_type == 1 and action_type == 1:
        return "FIRST_UP"
    elif tap_type == 3 and action_type == 0:
        return "SECOND_DOWN_DOUBLE_TAP"
    elif tap_type == 3 and action_type == 2:
        return "SECOND_MOVE_DOUBLE_TAP"
    elif tap_type == 3 and action_type == 1:
        return "SECOND_UP_DOUBLE_TAP"
    else:
        return "UNKNOWN"


def preprocess_one_finger_touch_events(one_finger_touch_event_df):
    one_finger_touch_event_df["Action"] = one_finger_touch_event_df.apply(
        lambda row: map_type(row["Tap_type"], row["Action_type"]), axis=1)
    one_finger_touch_event_df = one_finger_touch_event_df.sort_values(by=["ActivityID", "PressTime", "Systime"])

    one_finger_touch_event_df = timestamp_to_date(one_finger_touch_event_df)

    return one_finger_touch_event_df


def extract_one_finger_touch_event_features(one_finger_touch_event_df):
    features = []

    one_finger_touch_event_df = preprocess_one_finger_touch_events(one_finger_touch_event_df)

    max_x = math.ceil(one_finger_touch_event_df["X"].max() / 1000) * 1000
    max_y = math.ceil(one_finger_touch_event_df["Y"].max() / 1000) * 1000

    one_hot_encodings = False

    for activity_id, one_finger_touch_events_df_grouped in one_finger_touch_event_df.groupby("ActivityID"):
        one_finger_touch_events_df_grouped = one_finger_touch_events_df_grouped.sort_values(
            by=["PressTime", "Systime"]).reset_index(drop=True)

        i = 0
        while i < len(one_finger_touch_events_df_grouped):
            start_row = one_finger_touch_events_df_grouped.iloc[i]

            # ActivityID is composed as SubjectID (6 digits) + Session_number (between 01 and 24) + ContentID + Run-time determined Counter value
            one_finger_touch_event_features = {"activity_id": activity_id,
                                               "user_id": int(str(activity_id)[:6]),
                                               "session_number": int(str(activity_id)[6:8]),
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
                                               "move_actions_second": 0,
                                               "phone_orientation": 0
                                               }

            if start_row["Action"] == "FIRST_DOWN_SINGLE_TAP" or start_row["Action"] == "FIRST_DOWN_DOUBLE_TAP":
                one_finger_touch_event_features["start_timestamps"] = start_row["Systime"]
                one_finger_touch_event_features["hour_sin"] = start_row["Hour_Sin"]
                one_finger_touch_event_features["hour_cos"] = start_row["Hour_Cos"]
                one_finger_touch_event_features["dow_sin"] = start_row["DoW_Sin"]
                one_finger_touch_event_features["dow_cos"] = start_row["DoW_Cos"]
                one_finger_touch_event_features["month_sin"] = start_row["Month_Sin"]
                one_finger_touch_event_features["month_cos"] = start_row["Month_Cos"]
                one_finger_touch_event_features["is_weekend"] = start_row["Is_Weekend"]
                one_finger_touch_event_features["part_of_day"] = start_row["Part_Of_Day"]
                one_finger_touch_event_features["scenario"] = 0
                one_finger_touch_event_features["down_up_duration_ms"] = start_row["PressTime"]
                one_finger_touch_event_features["down_down_duration_ms"] = start_row["PressTime"]
                one_finger_touch_event_features["start_x"] = start_row["X"]
                one_finger_touch_event_features["start_y"] = start_row["Y"]
                one_finger_touch_event_features["start_quadrant"] = get_quadrant(start_row["X"],
                                                                                 start_row["Y"],
                                                                                 max_x, max_y)
                one_finger_touch_event_features["phone_orientation"] = start_row["Phone_orientation"]

                j = i + 1
                while j < len(one_finger_touch_events_df_grouped):
                    next_row = one_finger_touch_events_df_grouped.iloc[j]

                    one_finger_touch_event_features["phone_orientation"] += next_row["Phone_orientation"]

                    if next_row["Action"] == "SECOND_DOWN_DOUBLE_TAP":
                        one_finger_touch_event_features["scenario"] = 1

                    if next_row["Action"] == "SECOND_MOVE_DOUBLE_TAP" and start_row[
                        "Action"] == "FIRST_DOWN_DOUBLE_TAP":
                        one_finger_touch_event_features["move_actions_second"] += 1

                    # Avoid two consecutive DOWN events bug by checking if the next event is UP
                    # Common lines for both endings: single and double tap
                    # Final row if it is a single tap scenario (one DOWN + one UP)
                    # Final row in the sequence of a double tap scenario (2 DOWN + 2 UP events + X MOVE events)
                    if (next_row["Action"] == "FIRST_UP" and start_row["Action"] == "FIRST_DOWN_SINGLE_TAP") or (
                            next_row["Action"] == "SECOND_UP_DOUBLE_TAP" and start_row[
                        "Action"] == "FIRST_DOWN_DOUBLE_TAP"):
                        one_finger_touch_event_features["down_up_duration_ms"] -= next_row["PressTime"]
                        one_finger_touch_event_features["down_up_duration_ms"] = abs(
                            one_finger_touch_event_features["down_up_duration_ms"])
                        one_finger_touch_event_features["up_down_duration_ms"] = next_row["PressTime"]

                        one_finger_touch_event_features["contact_size_avg"] = (start_row["Contact_size"]
                                                                               + next_row["Contact_size"]) / 2

                        move_actions = one_finger_touch_event_features["move_actions_second"]
                        total_down_up_actions = 2
                        if move_actions > 0:
                            total_down_up_actions = 4
                        one_finger_touch_event_features["phone_orientation"] /= (total_down_up_actions + move_actions)
                        one_finger_touch_event_features["phone_orientation"] = round(
                            one_finger_touch_event_features["phone_orientation"])

                        # These are more specific to double taps but are executed also in one tap scenario for consistency (start_x=end_x, start_quadrant=end_quadrant, X_coord_distance,direction,touch_length,touch_angle=0)
                        one_finger_touch_event_features["end_x"] = next_row["X"]
                        one_finger_touch_event_features["end_y"] = next_row["Y"]

                        one_finger_touch_event_features["end_quadrant"] = get_quadrant(next_row["X"],
                                                                                       next_row["Y"],
                                                                                       max_x, max_y)

                        one_finger_touch_event_features["X_coord_distance"] = next_row["X"] - start_row["X"]
                        one_finger_touch_event_features["Y_coord_distance"] = next_row["Y"] - start_row["Y"]
                        one_finger_touch_event_features["direction"] = get_movement_direction(
                            one_finger_touch_event_features["X_coord_distance"],
                            one_finger_touch_event_features["Y_coord_distance"])

                        one_finger_touch_event_features[
                            "touch_length_euclidean_distance"] = get_euclidean_distance(start_row["X"],
                                                                                        start_row["Y"],
                                                                                        next_row["X"],
                                                                                        next_row["Y"])
                        one_finger_touch_event_features["touch_angle"] = get_angle(start_row["X"],
                                                                                   start_row["Y"],
                                                                                   next_row["X"],
                                                                                   next_row["Y"])

                        i = j
                        break

                    j += 1

                if j + 1 >= len(one_finger_touch_events_df_grouped):
                    if len(features) > 0:
                        one_finger_touch_event_features["down_down_duration_ms"] = features[-1]["down_down_duration_ms"]
                        one_finger_touch_event_features["up_down_duration_ms"] = features[-1]["up_down_duration_ms"]
                    else:
                        one_finger_touch_event_features["down_down_duration_ms"] = one_finger_touch_event_features[
                            "down_up_duration_ms"]
                        one_finger_touch_event_features["up_down_duration_ms"] = one_finger_touch_event_features[
                            "down_up_duration_ms"]
                else:
                    next_row = one_finger_touch_events_df_grouped.iloc[j + 1]
                    if next_row["Action"] == "FIRST_DOWN_SINGLE_TAP" or next_row["Action"] == "FIRST_DOWN_DOUBLE_TAP":
                        one_finger_touch_event_features["down_down_duration_ms"] -= next_row["PressTime"]
                        one_finger_touch_event_features["down_down_duration_ms"] = abs(
                            one_finger_touch_event_features["down_down_duration_ms"])

                        one_finger_touch_event_features["up_down_duration_ms"] -= next_row["PressTime"]
                        one_finger_touch_event_features["up_down_duration_ms"] = abs(
                            one_finger_touch_event_features["up_down_duration_ms"])
                    # For bugged situations where there are two consecutive UP events (second UP event doesn"t have a DOWN pair)
                    else:
                        one_finger_touch_event_features["down_down_duration_ms"] = features[-1]["down_down_duration_ms"]
                        one_finger_touch_event_features["up_down_duration_ms"] = features[-1]["up_down_duration_ms"]
                features.append(one_finger_touch_event_features)
            i += 1

    features_df = pd.DataFrame(features)

    columns_to_average = ["X_coord_distance", "Y_coord_distance", "touch_length_euclidean_distance", "touch_angle"]

    means = (
        features_df[features_df["scenario"] == 0]
        .replace(0, pd.NA)[columns_to_average]
        .mean(skipna=True)
    )

    for col in columns_to_average:
        mask = (features_df["scenario"] == 0) & (features_df[col] == 0)
        features_df.loc[mask, col] = means[col]

    categorical_cols_to_encode = ["scenario", "direction", "start_quadrant", "end_quadrant", "phone_orientation",
                                  "part_of_day"]

    if one_hot_encodings:
        features_df = pd.get_dummies(features_df, columns=categorical_cols_to_encode, prefix_sep="_")

    return features_df
