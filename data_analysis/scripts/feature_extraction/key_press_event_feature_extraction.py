# For some reason, the Systime (absolute timestamps) for UP (PressType = 1) event is after
# the DOWN (PressType = 0) event, even if PressTime (relative timestamp) is in logical order,
# the DOWN event has the lower value
# -> the sort will be made by PressTime
#
# Relevant dataset sample:
#       Systime   PressTime   PressType    KeyID
# 1396227050792	    7630074		      0	     105
# 1396227050527	    7630111		      1	     105
# 1396227055319	    7634604		      0	      32
# 1396227055087	    7634674		      1	      32
# 1396227057466	    7636750		      0	      -5
# 1396227057225	    7636807		      1	      -5
# 1396227057870	    7637156		      0	      -5
# 1396227057631	    7637218		      1	      -5
# 1396227059245	    7638531		      0	      -1
# 1396227059025	    7638610		      1	      -1
# 1396227059812	    7639097		      0	     105
# 1396227059578	    7639160		      1	     105

# There is a bug in the dataset where a UP event doesn't have a previous DOWN event
# Example:
#       Systime   PressTime   PressType    KeyID
# 1396228408450	    8988019		      1	      97
# 1396228409063	    8988350		      0	     116
# 1396228408817	    8988402		      1	     116
# 1396228410314	    8989600		      0	      32
# 1396228410084	    8989664		      1	      32
# 1396228410429	    8990000		      1	     116 -> BUG/ERROR
# 1396228410853	    8990237		      0	      97
# 1396228410703	    8990290		      1	      97
# 1396228410872	    8990441		      0	     115
# 1396228410909	    8990494		      1	     115
# -> This case must be handled in code
#
# There is a bug in the dataset where multiple UP events do not have a previous DOWN event
#       Systime   PressTime   PressType    KeyID
# 1399418033501	    1935672		      0	     103
# 1399418033552	    1935747		      1	     103
# 1399418033898	    1935790		      0	      32
# 1399418033716	    1935876		      1	      32
# 1399418034398	    1936591		      1	     120 -> BUG/ERROR
# 1399418034599	    1936796		      1	     101 -> BUG/ERROR
# 1399418034828	    1936850		      0	     107
# 1399418034763	    1936958		      1	     107
# -> This case must be handled in code
#
# Another bug was when PressTime values of a UP and DOWN events are equal and the data is ordered as DOWN, DOWN, UP, UP
#       Systime   PressTime   PressType    KeyID
# 1402005446283	     401949		      0	     116
# 1402005446690	     402067		      0	      32 -> BUG/ERROR
# 1402005446379	     402067		      1	     116 -> BUG/ERROR
# 1402005446495	     402184		      1	      32
# -> This case was handled by sorting also by Systime, after PressTime
#
# Another bug is where a DOWN event doesn't have a post UP (Release) event
#       Systime   PressTime   PressType    KeyID
# 1396567233939	    1524980		      0	      32
# 1396567233732	    1525076		      1	      32
# 1396567234197	    1525375		      0	     116
# 1396567234113	    1525455		      1	     116
# 1396567234226	    1525541		      0	     104 -> BUG/ERROR
# 1396567235082	    1526123		      0 	  32
# 1396567234896	    1526241		      1	      32
# 1396567235415	    1526457		      0	     115
# 1396567235208	    1526552		      1	     115
# -> This case must be handled in code
#
# Another bug is where a DOWN event doesn't have a post UP (Release) event and is the last row
#       Systime   PressTime   PressType    KeyID
# 1399505036988	    1408181	  	      0	     115
# 1399505036906	    1408374	  	      1	     115
# 1399505037006	    1408450	  	      0	      97 -> BUG/ERROR
# -> This case must be handled in code

import pandas as pd

from scripts.Utils.date_transformation import timestamp_to_date


def preprocess_key_press_events(key_press_event_df):
    key_press_event_df = timestamp_to_date(key_press_event_df)

    return key_press_event_df


def extract_key_press_event_features(key_press_event_df):
    features = []

    key_press_event_df = preprocess_key_press_events(key_press_event_df)

    one_hot_encodings = True

    for activity_id, key_press_event_df_grouped in key_press_event_df.groupby("ActivityID"):
        key_press_event_df_grouped = key_press_event_df_grouped.sort_values(by=["PressTime", "Systime"]).reset_index(
            drop=True)

        key_press_event_df_grouped_length = len(key_press_event_df_grouped)

        # ActivityID is composed as SubjectID (6 digits) + Session_number (between 01 and 24) + ContentID + Run-time determined Counter value
        key_press_event_features = {"activity_id": activity_id,
                                    "user_id": int(str(activity_id)[:6]),
                                    "session_number": int(str(activity_id)[6:8]),
                                    "start_timestamps": key_press_event_df_grouped.iloc[0]["Systime"],
                                    "session_duration_ms": key_press_event_df_grouped.iloc[0]["PressTime"],
                                    "hour_sin": key_press_event_df_grouped.iloc[0]["Hour_Sin"],
                                    "hour_cos": key_press_event_df_grouped.iloc[0]["Hour_Cos"],
                                    "dow_sin": key_press_event_df_grouped.iloc[0]["DoW_Sin"],
                                    "dow_cos": key_press_event_df_grouped.iloc[0]["DoW_Cos"],
                                    "month_sin": key_press_event_df_grouped.iloc[0]["Month_Sin"],
                                    "month_cos": key_press_event_df_grouped.iloc[0]["Month_Cos"],
                                    "is_weekend": key_press_event_df_grouped.iloc[0]["Is_Weekend"],
                                    "part_of_day": key_press_event_df_grouped.iloc[0]["Part_Of_Day"],
                                    "down_up_duration_ms_avg": 0,
                                    "down_down_duration_ms_avg": 0,
                                    "up_down_duration_ms_avg": 0,
                                    "key_ids": [],
                                    "key_ids_occurrences": [],
                                    "total_unique_keys_used": 0,
                                    "total_keys_pressed": 0,
                                    "characters_per_second": 0,
                                    "phone_orientation": 0
                                    }

        i = 0
        # length - 1 because DOWN (Press) events are processed together with (i + 1) UP (Release) events
        while i < key_press_event_df_grouped_length - 1:
            # row = DOWN (Press) event
            row = key_press_event_df_grouped.iloc[i]

            # PressType 0: Finger Down, 1: Finger Up
            # Current row should be only DOWN (Press) events, otherwise skip it
            if row["PressType"] == 1:
                i += 1
                continue

            # next_row = UP (Release) event
            next_row = key_press_event_df_grouped.iloc[i + 1]

            # Two consecutive DOWN events: the current row doesn't have a UP (Release) pair event. Skip the current row
            if next_row["PressType"] == 0:
                i += 1
                continue

            # Two consecutive UP events: the next row and the second next row are both UP (Release) events
            # -> the second next row doesn't have a DOWN (Press) pair event -> skip and ignore it
            second_next_row_valid = False
            second_next_row = None
            j = i + 2
            while j < key_press_event_df_grouped_length and second_next_row_valid is False:
                # second_next_row = DOWN (Press) event
                second_next_row = key_press_event_df_grouped.iloc[j]

                if second_next_row["PressType"] == 0:
                    second_next_row_valid = True
                else:
                    j += 1
                    second_next_row = None

            key_press_event_features["phone_orientation"] += row["Phone_orientation"]

            key_press_event_features["down_up_duration_ms_avg"] += (next_row["PressTime"] - row["PressTime"])
            if second_next_row_valid and second_next_row is not None:
                key_press_event_features["down_down_duration_ms_avg"] += (
                        second_next_row["PressTime"] - row["PressTime"])

                key_press_event_features["up_down_duration_ms_avg"] += (
                        next_row["PressTime"] - second_next_row["PressTime"])

            current_row_key_id = row["KeyID"]
            if current_row_key_id in key_press_event_features["key_ids"]:
                index = key_press_event_features["key_ids"].index(current_row_key_id)
                key_press_event_features["key_ids_occurrences"][index] += 1
            else:
                key_press_event_features["key_ids"].append(int(current_row_key_id))
                key_press_event_features["key_ids_occurrences"].append(1)

            # If the second statement is true, it means that a DOWN event doesn't have a post UP (Release) event and is the last row
            # The final row
            if i + 2 == key_press_event_df_grouped_length or i + 2 >= key_press_event_df_grouped_length - 1:
                key_press_event_features["session_duration_ms"] -= row["PressTime"]
                key_press_event_features["session_duration_ms"] = abs(key_press_event_features["session_duration_ms"])

                total_characters_pressed = sum(key_press_event_features["key_ids_occurrences"])
                key_press_event_features["characters_per_second"] = total_characters_pressed / (
                        key_press_event_features["session_duration_ms"] / 1000)

                key_press_event_features["total_unique_keys_used"] = len(key_press_event_features["key_ids"])
                key_press_event_features["total_keys_pressed"] = sum(key_press_event_features["key_ids_occurrences"])

                key_press_event_features["phone_orientation"] /= total_characters_pressed
                key_press_event_features["phone_orientation"] = round(key_press_event_features["phone_orientation"])

                key_press_event_features["down_up_duration_ms_avg"] /= (total_characters_pressed / 2)
                key_press_event_features["up_down_duration_ms_avg"] /= (total_characters_pressed / 2)
                key_press_event_features["down_down_duration_ms_avg"] /= (total_characters_pressed / 2)

                features.append(key_press_event_features)

            if second_next_row_valid is False:
                # The bugged UP event(s) row is(are) the last row
                i = j
                continue

            if i + 2 < j:
                # Skip the UP event row(s) in the next iteration which does(do) not have a DOWN event row pair
                i = j - 2

            # Skip the finger UP event
            i += 2

    categorical_cols_to_encode = ["phone_orientation", "part_of_day"]

    features_df = pd.DataFrame(features)
    if one_hot_encodings:
        features_df = pd.get_dummies(features_df, columns=categorical_cols_to_encode, prefix_sep="_")

    return features_df
