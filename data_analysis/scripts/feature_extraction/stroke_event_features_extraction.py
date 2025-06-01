import pandas as pd


# The table has some rows with NULL values
def preprocess_stroke_events(stroke_event_df):
    stroke_event_df = stroke_event_df.dropna()
    return stroke_event_df


def extract_stroke_event_features(stroke_event_df):
    features = []

    stroke_event_df = preprocess_stroke_events(stroke_event_df)

    for activity_id, stroke_event_df_grouped in stroke_event_df.groupby("ActivityID"):
        stroke_event_df_grouped = stroke_event_df_grouped.sort_values(
            by=["Systime", "Begin_time"]).reset_index(drop=True)

        # ActivityID is composed as SubjectID (6 digits) + Session_number (between 01 and 24) + ContentID + Run-time determined Counter value
        stroke_event_features = {"activity_id": activity_id,
                                 "user_id": int(str(activity_id)[:6]),
                                 "session_number": int(str(activity_id)[6:8]),
                                 "start_timestamps": stroke_event_df_grouped.iloc[0]["Systime"],
                                 "duration_ms_avg": 0,
                                 "start_x_avg": 0, "start_y_avg": 0, "start_size_avg": 0,
                                 "end_x_avg": 0, "end_y_avg": 0, "end_size_avg": 0,
                                 "speed_x_avg": 0, "speed_y_avg": 0, "phone_orientation_avg": 0
                                 }

        i = 0
        while i < len(stroke_event_df_grouped):
            stroke_event_start_row = stroke_event_df_grouped.iloc[i]

            stroke_event_features["duration_ms_avg"] += (stroke_event_start_row["End_time"] -
                                                         stroke_event_start_row["Begin_time"])
            stroke_event_features["start_x_avg"] += stroke_event_start_row["Start_X"]
            stroke_event_features["start_y_avg"] += stroke_event_start_row["Start_Y"]
            stroke_event_features["start_size_avg"] += stroke_event_start_row["Start_size"]
            stroke_event_features["end_x_avg"] += stroke_event_start_row["End_X"]
            stroke_event_features["end_y_avg"] += stroke_event_start_row["End_Y"]
            stroke_event_features["end_size_avg"] += stroke_event_start_row["End_size"]
            stroke_event_features["speed_x_avg"] += stroke_event_start_row["Speed_X"]
            stroke_event_features["speed_y_avg"] += stroke_event_start_row["Speed_Y"]
            stroke_event_features["phone_orientation_avg"] += stroke_event_start_row["Phone_orientation"]

            # Final row within the activity
            if i + 1 == len(stroke_event_df_grouped):
                stroke_event_features["duration_ms_avg"] /= (i + 1)
                stroke_event_features["start_x_avg"] /= (i + 1)
                stroke_event_features["start_y_avg"] /= (i + 1)
                stroke_event_features["start_size_avg"] /= (i + 1)
                stroke_event_features["end_x_avg"] /= (i + 1)
                stroke_event_features["end_y_avg"] /= (i + 1)
                stroke_event_features["end_size_avg"] /= (i + 1)
                stroke_event_features["speed_x_avg"] /= (i + 1)
                stroke_event_features["speed_y_avg"] /= (i + 1)
                stroke_event_features["phone_orientation_avg"] /= (i + 1)

            i += 1

        features.append(stroke_event_features)

    return pd.DataFrame(features)
