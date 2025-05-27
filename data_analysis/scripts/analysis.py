import pandas as pd

import scripts.database_operations as db
import data.constants as constants
from scripts.feature_extraction.touch_event_feature_extraction import preprocess_touch_events, \
    extract_touch_event_features


def init():
    with (db.get_database_connection(database_password="oracle") as connection):
        with connection.cursor() as cursor:
            table_names = constants.relevant_tables

            results_rows = db.read_from_database(cursor, table_names)

            dataframes = []

            for i, result_rows in enumerate(results_rows, start=0):
                dataframes.append(pd.DataFrame(result_rows, columns=constants.table_headers[i]))

            return dataframes


def main():
    activity_df, touch_event_df, key_press_event_df, one_finger_touch_event_df, scroll_event_df, stroke_event_df = init()

    touch_event_df_clean = preprocess_touch_events(touch_event_df)
    features = extract_touch_event_features(touch_event_df_clean)

    pd.set_option('display.max_columns', None)
    print(features)


if __name__ == "__main__":
    print()
    main()
