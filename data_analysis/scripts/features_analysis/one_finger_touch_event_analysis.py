from scripts.Utils.classifiers_reports import print_classifier_performance
from scripts.Utils.prepare_analysis_data import prepare_analysis_data
from scripts.algorithms.k_nearest_neighbors import k_nearest_neighbors
from scripts.algorithms.random_forest import random_forest_classifier
from scripts.algorithms.support_vector_machine import support_vector_machine


def one_finger_touch_event_analysis(touch_event_df, classifier_name):
    columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps"]

    columns_names_to_drop_array_1 = ["user_id", "activity_id", "session_number", "start_timestamps",
                                   "move_actions_second", "scenario", "start_quadrant", "end_quadrant", "scenario",
                                   "direction"]

    X, y, X_train, X_test, y_train, y_test, X_scaled, X_train_scaled, X_test_scaled = prepare_analysis_data(
        df=touch_event_df, csv_file_path="..\\data\\one_finger_touch_event_features.csv",
        column_name_to_predict="user_id", columns_names_to_drop_array=columns_names_to_drop_array)

    y_pred = None
    y_scores = None
    classifier = None
    if classifier_name == "k-NN":
        best_k = 0
        y_pred, y_scores, classifier = k_nearest_neighbors(X_train_scaled=X_train_scaled, X_test_scaled=X_test_scaled,
                                                           y_train=y_train, best_k=best_k)

        # Without activity_id, session_number and start_timestamps, the best k value was 33 with 33.45% accuracy in a one shot test accuracy
        # After adding the new properties down_down_duration_ms, up_down_duration_ms, X_coord_distance_avg and Y_coord_distance_avg, the accuracy increased to 34.02% (k = 24)
        # After removing the previous added properties and added the following properties: hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms_avg, down_down_duration_ms_avg, up_down_duration_ms_avg, start_x, start_y, end_x, end_y, start_quadrant, end_quadrant, X_coord_distance, Y_coord_distance, direction, touch_length_euclidean_distance, touch_angle and contact_size_avg, the best k = 5 with 78.95% accuracy, 0.0107 FAR, 0.2104 FRR and 0.0478 EER with 0.2000 threshold
        #   after removing move_actions_second, scenario, start_quadrant, end_quadrant, scenario and direction, the best k = 5 with 79.02% accuracy, 0.0106 FAR, 0.2097 FRR and 0.0464 EER with 0.2000 threshold
    elif classifier_name == "Random Forest":
        best_n_estimators = 151
        y_pred, y_scores, classifier = random_forest_classifier(X=X, X_train=X_train, X_test=X_test, y_train=y_train,
                                                                best_n_estimators=best_n_estimators)

        # After best_n_estimators=100, the accuracy is relatively constant at around 43%
        #   but best_n_estimators=190->200 showed the best accuracy of 43%+
        # After adding the new properties down_down_duration_ms, up_down_duration_ms, X_coord_distance_avg and Y_coord_distance_avg, an increase of 2% in accuracy
        #   was recorded, from 43% to 45.18% (best_n_estimators=151)
        # After removing the previous added properties and added the following properties: hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms_avg, down_down_duration_ms_avg, up_down_duration_ms_avg, start_x, start_y, end_x, end_y, start_quadrant, end_quadrant, X_coord_distance, Y_coord_distance, direction, touch_length_euclidean_distance, touch_angle and contact_size_avg, the best best_n_estimators = 201 with 89.00% accuracy, 0.0056 FAR, 0.1099 FRR and 0.0217 EER with 0.1525 threshold
        #   after removing move_actions_second, scenario, start_quadrant, end_quadrant, scenario and direction, the best best_n_estimators = 5 with 88.91% accuracy, 0.0057 FAR, 0.1108 FRR and 0.0220 EER with 0.1563 threshold
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
        # (too much time to wait, aborted it) After removing the previous added properties and added the following properties: hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms_avg, down_down_duration_ms_avg, up_down_duration_ms_avg, start_x, start_y, end_x, end_y, start_quadrant, end_quadrant, X_coord_distance, Y_coord_distance, direction, touch_length_euclidean_distance, touch_angle and contact_size_avg, the best params are: svm__C: ?, svm__gama: 0.? and svm__kernel: rbf with ?% accuracy, 0.? FAR, 0.? FRR and 0.? EER with ?.? threshold
        #   instead, tried the arbitrary values of: svm__C: 100, svm__gama: 0.01 and svm__kernel: rbf with 79.17% accuracy, 0.010 FAR, 0.2082 FRR and 0.0550 EER with 18.70 threshold
        #   after removing move_actions_second, scenario, start_quadrant, end_quadrant, scenario and direction, tried the arbitrary values of: svm__C: 100, svm__gama: 0.01 and svm__kernel: rbf with 77.14% accuracy, 0.0116 FAR, 0.22285 FRR and 0.0572 EER with 18.74 threshold
    else:
        print(f"{classifier_name} is not implemented.")

    print_classifier_performance(classifier_name=classifier_name, classifier=classifier, X_scaled=X_scaled, y=y,
                                 y_test=y_test, y_pred=y_pred, y_scores=y_scores)
