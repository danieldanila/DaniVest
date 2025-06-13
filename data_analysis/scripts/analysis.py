import pandas as pd

import scripts.database_operations as db
import data.constants as constants
from scripts.feature_extraction.key_press_event_feature_extraction import extract_key_press_event_features
from scripts.feature_extraction.one_finger_touch_event_feature_extraction import extract_one_finger_touch_event_features
from scripts.feature_extraction.scroll_event_feature_extraction import extract_scroll_event_features
from scripts.feature_extraction.stroke_event_features_extraction import extract_stroke_event_features
from scripts.feature_extraction.touch_event_feature_extraction import extract_touch_event_features
from scripts.features_analysis.key_press_event_analysis import key_press_event_analysis
from scripts.features_analysis.one_finger_touch_event_analysis import one_finger_touch_event_analysis
from scripts.features_analysis.scroll_event_analysis import scroll_event_analysis
from scripts.features_analysis.stroke_event_analysis import stroke_event_analysis
from scripts.features_analysis.touch_event_analysis import touch_event_analysis


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
    #
    # touch_event_features_df = extract_touch_event_features(touch_event_df)
    # touch_event_features_df.to_csv("..\\data\\touch_event_features.csv")
    #
    key_press_event_features_df = extract_key_press_event_features(key_press_event_df)
    key_press_event_features_df.to_csv("..\\data\\key_press_event_features.csv")
    #
    # scroll_event_features_df = extract_scroll_event_features(scroll_event_df)
    # scroll_event_features_df.to_csv("..\\data\\scroll_event_features.csv")
    #
    # stroke_event_features_df = extract_stroke_event_features(stroke_event_df)
    # stroke_event_features_df.to_csv("..\\data\\stroke_event_features.csv")
    #
    # one_finger_touch_event_features_df = extract_one_finger_touch_event_features(one_finger_touch_event_df)
    # one_finger_touch_event_features_df.to_csv("..\\data\\one_finger_touch_event_features.csv")
    #
    # touch_event_analysis(None, classifier_name="k-NN")
    # touch_event_analysis(None, classifier_name="Random Forest")
    # touch_event_analysis(None, classifier_name="SVM")
    #
    # one_finger_touch_event_analysis(None, classifier_name="k-NN")
    # one_finger_touch_event_analysis(None, classifier_name="Random Forest")
    # one_finger_touch_event_analysis(None, classifier_name="SVM")
    #
    # scroll_event_analysis(None, classifier_name="k-NN")
    # scroll_event_analysis(None, classifier_name="Random Forest")
    # scroll_event_analysis(None, classifier_name="SVM")
    #
    # stroke_event_analysis(None, classifier_name="k-NN")
    # stroke_event_analysis(None, classifier_name="Random Forest")
    # stroke_event_analysis(None, classifier_name="SVM")

    key_press_event_analysis(key_press_event_features_df, classifier_name="k-NN")
    key_press_event_analysis(key_press_event_features_df, classifier_name="Random Forest")
    key_press_event_analysis(key_press_event_features_df, classifier_name="SVM")


if __name__ == "__main__":
    print()
    main()
