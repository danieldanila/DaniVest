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

    return one_finger_touch_event_df


def extract_one_finger_touch_event_features(one_finger_touch_event_df):
    features = []

    one_finger_touch_event_df = preprocess_one_finger_touch_events(one_finger_touch_event_df)

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
                                               "down_up_duration_ms": 0, "down_down_duration_ms": 0,
                                               "up_down_duration_ms": 0,
                                               "X_coord_first_avg": 0, "Y_coord_first_avg": 0,
                                               "Contact_size_first_avg": 0,
                                               "X_coord_second_avg": 0, "Y_coord_second_avg": 0,
                                               "Contact_size_second_avg": 0, "move_actions_second": 0,
                                               "Phone_orientation_avg": 0,
                                               "X_coord_distance_avg": 0, "Y_coord_distance_avg": 0
                                               }

            if start_row["Action"] == "FIRST_DOWN_SINGLE_TAP" or start_row["Action"] == "FIRST_DOWN_DOUBLE_TAP":
                one_finger_touch_event_features["start_timestamps"] = start_row["Systime"]
                one_finger_touch_event_features["scenario"] = start_row["Tap_type"]
                one_finger_touch_event_features["down_up_duration_ms"] = start_row["PressTime"]
                one_finger_touch_event_features["down_down_duration_ms"] = start_row["PressTime"]
                one_finger_touch_event_features["X_coord_first_avg"] = start_row["X"]
                one_finger_touch_event_features["Y_coord_first_avg"] = start_row["Y"]
                one_finger_touch_event_features["Contact_size_first_avg"] = start_row["Contact_size"]
                one_finger_touch_event_features["Phone_orientation_avg"] = start_row["Phone_orientation"]

                j = i + 1
                while j < len(one_finger_touch_events_df_grouped):
                    next_row = one_finger_touch_events_df_grouped.iloc[j]

                    one_finger_touch_event_features["Phone_orientation_avg"] += next_row["Phone_orientation"]

                    # Avoid two consecutive DOWN events bug by checking if the next event is UP
                    if next_row["Action"] == "FIRST_UP":
                        one_finger_touch_event_features["X_coord_first_avg"] += next_row["X"]
                        one_finger_touch_event_features["Y_coord_first_avg"] += next_row["Y"]
                        one_finger_touch_event_features["Contact_size_first_avg"] += next_row["Contact_size"]

                        # Final row if it is a single tap scenario (one DOWN + one UP)
                        if start_row["Action"] == "FIRST_DOWN_SINGLE_TAP":
                            one_finger_touch_event_features["down_up_duration_ms"] -= next_row["PressTime"]
                            one_finger_touch_event_features["down_up_duration_ms"] = abs(
                                one_finger_touch_event_features["down_up_duration_ms"])

                            one_finger_touch_event_features["X_coord_first_avg"] /= 2
                            one_finger_touch_event_features["Y_coord_first_avg"] /= 2
                            one_finger_touch_event_features["Contact_size_first_avg"] /= 2
                            one_finger_touch_event_features["Phone_orientation_avg"] /= 2

                            one_finger_touch_event_features["up_down_duration_ms"] = next_row["PressTime"]

                            i = j
                            break
                        # start_row["Action"] = FIRST_DOWN_DOUBLE_TAP
                        else:
                            one_finger_touch_event_features["scenario"] = next_row["Tap_type"]
                    # Second touch in a two touches scenario,
                    # next_row["Action"] possible remaining values:
                    # {"SECOND_DOWN_DOUBLE_TAP", "SECOND_MOVE_DOUBLE_TAP", "SECOND_UP_DOUBLE_TAP"}
                    else:
                        # Current touch event is a two touches scenario
                        one_finger_touch_event_features["X_coord_second_avg"] += next_row["X"]
                        one_finger_touch_event_features["Y_coord_second_avg"] += next_row["Y"]
                        one_finger_touch_event_features["Contact_size_second_avg"] += next_row["Contact_size"]

                        if next_row["Action"] == "SECOND_MOVE_DOUBLE_TAP":
                            one_finger_touch_event_features["move_actions_second"] += 1

                        # Final row in the sequence of a double tap scenario (2 DOWN + 2 UP events + X MOVE events)
                        if next_row["Action"] == "SECOND_UP_DOUBLE_TAP":
                            one_finger_touch_event_features["down_up_duration_ms"] -= next_row["PressTime"]
                            one_finger_touch_event_features["down_up_duration_ms"] = abs(
                                one_finger_touch_event_features["down_up_duration_ms"])

                            move_actions = one_finger_touch_event_features["move_actions_second"]

                            one_finger_touch_event_features["X_coord_first_avg"] /= 2
                            one_finger_touch_event_features["Y_coord_first_avg"] /= 2
                            one_finger_touch_event_features["Contact_size_first_avg"] /= 2
                            one_finger_touch_event_features["X_coord_second_avg"] /= (2 + move_actions)
                            one_finger_touch_event_features["Y_coord_second_avg"] /= (2 + move_actions)
                            one_finger_touch_event_features["Contact_size_second_avg"] /= (2 + move_actions)
                            one_finger_touch_event_features["Phone_orientation_avg"] /= (4 + move_actions)

                            one_finger_touch_event_features["up_down_duration_ms"] = next_row["PressTime"]

                            one_finger_touch_event_features["X_coord_distance_avg"] = one_finger_touch_event_features[
                                                                                          "X_coord_first_avg"] - \
                                                                                      one_finger_touch_event_features[
                                                                                          "X_coord_second_avg"]
                            one_finger_touch_event_features["Y_coord_distance_avg"] = one_finger_touch_event_features[
                                                                                          "Y_coord_first_avg"] - \
                                                                                      one_finger_touch_event_features[
                                                                                          "Y_coord_second_avg"]

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
                    # For bugged situations where there are two consecutive UP events (second UP event doesn't have a DOWN pair)
                    else:
                        one_finger_touch_event_features["down_down_duration_ms"] = features[-1]["down_down_duration_ms"]
                        one_finger_touch_event_features["up_down_duration_ms"] = features[-1]["up_down_duration_ms"]
                features.append(one_finger_touch_event_features)
            i += 1

    return pd.DataFrame(features)
