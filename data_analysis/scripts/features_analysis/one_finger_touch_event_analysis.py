from scripts.Utils.classifiers_reports import print_classifier_performance
from scripts.Utils.prepare_analysis_data import prepare_analysis_data
from scripts.algorithms.k_nearest_neighbors import k_nearest_neighbors
from scripts.algorithms.random_forest import random_forest_classifier
from scripts.algorithms.support_vector_machine import support_vector_machine


def one_finger_touch_event_analysis(touch_event_df, classifier_name):
    columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps"]

    X, y, X_train, X_test, y_train, y_test, X_scaled, X_train_scaled, X_test_scaled = prepare_analysis_data(
        df=touch_event_df, csv_file_path="..\\data\\one_finger_touch_event_features.csv",
        column_name_to_predict="user_id", columns_names_to_drop_array=columns_names_to_drop_array,
        column_name_to_mask="scenario", mask_condition_value=1,
        columns_names_to_average=["move_actions_second", "X_coord_second_avg", "Y_coord_second_avg",
                                  "Contact_size_second_avg"])

    y_pred = None
    y_scores = None
    classifier = None
    if classifier_name == "k-NN":
        best_k = 0
        y_pred, y_scores, classifier = k_nearest_neighbors(X_train_scaled=X_train_scaled, X_test_scaled=X_test_scaled,
                                                           y_train=y_train, best_k=best_k)

        # Without activity_id, session_number and start_timestamps, the best k value was 33 with 33.45% accuracy in a one shot test accuracy
        # After adding the new properties down_down_duration_ms, up_down_duration_ms, X_coord_distance_avg and Y_coord_distance_avg, the accuracy increased to 34.02% (k = 24)
    elif classifier_name == "Random Forest":
        best_k = 0
        y_pred, y_scores, classifier = random_forest_classifier(X=X, X_train=X_train, X_test=X_test, y_train=y_train,
                                                                best_k=best_k)

        # After k=100, the accuracy is relatively constant at around 43%
        #   but k=190->200 showed the best accuracy of 43%+
        # After adding the new properties down_down_duration_ms, up_down_duration_ms, X_coord_distance_avg and Y_coord_distance_avg, an increase of 2% in accuracy
        #   was recorded, from 43% to 45.18% (k=151)
    elif classifier_name == "SVM":
        best_c = 0
        best_gamma = 0
        best_kernel = "rbf"
        param_grid = {"svm__C": [10, 100, 1000],
                      "svm__gamma": [0.01, 0.1, 1.0, 10.0],
                      "svm__kernel": ["rbf"]}

        y_pred, y_scores, classifier = support_vector_machine(X=X, y=y, X_train_scaled=X_train_scaled,
                                                              X_test_scaled=X_test_scaled, y_train=y_train,
                                                              param_grid=param_grid, best_c=best_c,
                                                              best_gamma=best_gamma, best_kernel=best_kernel)

        # After 10 hours of executing, the best params are: svm__C: 1000, svm__gama: 1.0 and svm__kernel: rbf with 37.68% accuracy
    else:
        print(f"{classifier_name} is not implemented.")

    print_classifier_performance(classifier_name=classifier_name, classifier=classifier, X_scaled=X_scaled, y=y,
                                 y_test=y_test, y_pred=y_pred, y_scores=y_scores)
