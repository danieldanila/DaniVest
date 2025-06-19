from scripts.Utils.classifiers_reports import print_classifier_performance, get_classifier_performance
from scripts.Utils.prepare_analysis_data import prepare_analysis_data
from scripts.algorithms.k_nearest_neighbors import k_nearest_neighbors
from scripts.algorithms.random_forest import random_forest_classifier
from scripts.algorithms.support_vector_machine import support_vector_machine


def touch_event_analysis(touch_event_df, classifier_name, print_results=False):
    columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps"]

    X, y, X_train, X_test, y_train, y_test, X_scaled, X_train_scaled, X_test_scaled = prepare_analysis_data(
        df=touch_event_df, feature_name="touch_event",
        csv_file_path="..\\data\\features\\touch_event_features.csv",
        column_name_to_predict="user_id", columns_names_to_drop_array=columns_names_to_drop_array)

    y_pred = None
    y_scores = None
    classifier = None
    if classifier_name == "k-NN":
        best_k = 0
        y_pred, y_scores, classifier = k_nearest_neighbors(X_train_scaled=X_train_scaled, X_test_scaled=X_test_scaled,
                                                           y_train=y_train, best_k=best_k,
                                                           feature_name="touch_event")

        # 1. Without activity_id, session_number and start_timestamps, the best k value was 27 with 63% accuracy in a one shot test accuracy
        # 2. After adding the new properties down_down_duration_ms and up_down_duration_ms, no change in accuracy reported for k-NN classifier (best k = 21)
        # 3. After adding the new properties move_actions, X_coord_avg, Y_coord_avg, Contact_size_avg and dropping the properties specific to the first/second touch,
        #   the accuracy dropped to 58% (k = 21)
        # 4. After adding the new X_coord_distance_avg and Y_coord_distance_avg, the accuracy increased by 1% to 64% (k = 20)
        # 5. After removing the properties (X_coord_first_avg, Y_coord_first_avg, X_coord_second_avg, Y_coord_second_avg, Contact_size_first_avg, Contact_size_second_avg, move_actions, X_coord_avg, Y_coord_avg, X_coord_distance_avg, Y_coord_distance_avg) and added the following properties: (hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, start_x, start_y, end_x, end_y, start_quadrant, end_quadrant, X_coord_distance, Y_coord_distance, direction, touch_length_euclidean_distance, touch_angle and contact_size_avg), the best k = 1 with 86.76% accuracy, 0.0084 FAR, 0.1323 FRR and 0.1031 EER with 1.0 threshold
    elif classifier_name == "Random Forest":
        best_n_estimators = 201
        y_pred, y_scores, classifier = random_forest_classifier(X=X, X_train=X_train, X_test=X_test, y_train=y_train,
                                                                best_n_estimators=best_n_estimators,
                                                                feature_name="touch_event")

        # 1. After best_n_estimators=100, the accuracy is relatively constant at around 68%
        #   but best_n_estimators=190->200 showed the best accuracy of 68.4%+
        # 2. After adding the new properties down_down_duration_ms and up_down_duration_ms, an increase of 2% in accuracy
        #   was recorded, from 68% to 70%
        # 3. After adding the new properties move_actions, X_coord_avg, Y_coord_avg, Contact_size_avg and dropping the properties specific to the first/second touch,
        #   the accuracy dropped to 64%
        # 5. After removing the properties (X_coord_first_avg, Y_coord_first_avg, X_coord_second_avg, Y_coord_second_avg, Contact_size_first_avg, Contact_size_second_avg, move_actions, X_coord_avg, Y_coord_avg, X_coord_distance_avg, Y_coord_distance_avg) and added the following properties: (hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, start_x, start_y, end_x, end_y, start_quadrant, end_quadrant, X_coord_distance, Y_coord_distance, direction, touch_length_euclidean_distance, touch_angle and contact_size_avg), the best best_n_estimators = 201 with 93.50% accuracy, 0.0043 FAR, 0.0649 FRR and 0.0148 EER with 0.1779 threshold
    elif classifier_name == "SVM":
        best_c = 0
        best_gamma = 0
        best_kernel = "rbf"

        # 1?. After 7 hours of executing, the best params are: svm__C: 100, svm__gama: 0.1 and svm__kernel: rbf with 63.93% accuracy
        param_grid_old = {"svm__C": [0.001, 0.01, 0.1, 1, 10, 100],
                          "svm__gamma": [0.0001, 0.001, 0.01, 0.1, 1.0],
                          "svm__kernel": ["linear", "rbf"]}

        # 2?. After 1.5 hours of executing, the best params are: svm__C: 1000, svm__gama: 1.0 and svm__kernel: rbf with 66.39% accuracy
        # 5. After removing the properties (X_coord_first_avg, Y_coord_first_avg, X_coord_second_avg, Y_coord_second_avg, Contact_size_first_avg, Contact_size_second_avg, move_actions, X_coord_avg, Y_coord_avg, X_coord_distance_avg, Y_coord_distance_avg) and added the following properties: (hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, start_x, start_y, end_x, end_y, start_quadrant, end_quadrant, X_coord_distance, Y_coord_distance, direction, touch_length_euclidean_distance, touch_angle and contact_size_avg), the best params are: svm__C: 1000, svm__gama: 0.01 and svm__kernel: rbf with 91.97% accuracy, 0.005 FAR, 0.0802 FRR and 0.0342 EER with 18.89 threshold
        param_grid = {"svm__C": [10, 100, 1000],
                      "svm__gamma": [0.01, 0.1, 1.0, 10.0],
                      "svm__kernel": ["rbf"]}

        # 3?. Executed for more than 3 hours, left it for the moment
        param_grid_old = {"svm__C": [1000, 10000, 100000],
                          "svm__gamma": [0.01, 0.1, 1.0, 10.0],
                          "svm__kernel": ["rbf"]}

        y_pred, y_scores, classifier = support_vector_machine(X=X, y=y, X_train_scaled=X_train_scaled,
                                                              X_test_scaled=X_test_scaled, y_train=y_train,
                                                              param_grid=param_grid, best_c=best_c,
                                                              best_gamma=best_gamma, best_kernel=best_kernel,
                                                              feature_name="touch_event")
    else:
        print(f"{classifier_name} is not implemented.")

    accuracy, far, frr, mean_eer, mean_threshold, cv = get_classifier_performance(classifier=classifier,
                                                                                  X_scaled=X_scaled, y=y, y_test=y_test,
                                                                                  y_pred=y_pred, y_scores=y_scores)

    if print_results:
        print_classifier_performance(classifier_name=classifier_name, y_test=y_test, y_pred=y_pred, accuracy=accuracy,
                                     far=far, frr=frr, mean_eer=mean_eer, mean_threshold=mean_threshold, cv=cv)

    return accuracy, far, frr, mean_eer, mean_threshold, cv
