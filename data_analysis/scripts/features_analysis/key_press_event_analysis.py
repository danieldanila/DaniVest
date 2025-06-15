from scripts.Utils.classifiers_reports import print_classifier_performance, get_classifier_performance
from scripts.Utils.prepare_analysis_data import prepare_analysis_data
from scripts.algorithms.k_nearest_neighbors import k_nearest_neighbors
from scripts.algorithms.random_forest import random_forest_classifier
from scripts.algorithms.support_vector_machine import support_vector_machine


def key_press_event_analysis(key_press_event_df, classifier_name, print_results=False):
    columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps", "key_ids",
                                   "key_ids_occurrences"]

    X, y, X_train, X_test, y_train, y_test, X_scaled, X_train_scaled, X_test_scaled = prepare_analysis_data(
        df=key_press_event_df, csv_file_path="..\\data\\key_press_event_features.csv",
        column_name_to_predict="user_id", columns_names_to_drop_array=columns_names_to_drop_array)

    y_pred = None
    classifier = None
    y_scores = None
    if classifier_name == "k-NN":
        best_k = 0
        y_pred, y_scores, classifier = k_nearest_neighbors(X_train_scaled=X_train_scaled, X_test_scaled=X_test_scaled,
                                                           y_train=y_train, best_k=best_k)

        # Without activity_id, session_number, start_timestamps, key_ids and key_ids_occurrences, the best k value was 1 with 62% accuracy in a one shot test accuracy
        # After adding the new properties: session_duration_ms, hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms_avg, down_down_duration_ms_avg, up_down_duration_ms_avg, total_unique_keys_used, total_keys_pressed and characters_per_second, and hot encodings was false, the best k = 1 with 88% accuracy, 0.0063 FAR, 0.12 FRR and 0.0625 EER with 1.0 threshold
        #   after setting one hot encoding to true, the best k = 1 with 87% accuracy, 0.0068 FAR, 0.13 FRR and 0.0675 EER with 1.0 threshold
    elif classifier_name == "Random Forest":
        best_n_estimators = 0
        y_pred, y_scores, classifier = random_forest_classifier(X=X, X_train=X_train, X_test=X_test, y_train=y_train,
                                                                best_n_estimators=best_n_estimators)

        # After best_n_estimators=100, the accuracy is relatively constant at around 59.94%
        #   but best_n_estimators=201 showed the best accuracy of 62.57%
        # After adding the new properties: session_duration_ms, hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms_avg, down_down_duration_ms_avg, up_down_duration_ms_avg, total_unique_keys_used, total_keys_pressed and characters_per_second, and hot encodings was false, the best best_n_estimators = 151 with 86% accuracy, 0.0073 FAR, 0.14 FRR and 0.0179 EER with 0.4903 threshold
        #   after setting one hot encoding to true, the best best_n_estimators = 101 with 86% accuracy, 0.0072 FAR, 0.14 FRR and 0.0169 EER with 0.4818 threshold
    elif classifier_name == "SVM":
        best_c = 100
        best_gamma = 0.01
        best_kernel = "rbf"
        param_grid = {"svm__C": [10, 100, 1000],
                      "svm__gamma": [0.01, 0.1, 1.0, 10.0],
                      "svm__kernel": ["rbf"]}

        y_pred, y_scores, classifier = support_vector_machine(X=X, y=y, X_train_scaled=X_train_scaled,
                                                              X_test_scaled=X_test_scaled, y_train=y_train,
                                                              param_grid=param_grid, best_c=best_c,
                                                              best_gamma=best_gamma, best_kernel=best_kernel)

        # After 1 hour of executing, the best params are: svm__C: 1000, svm__gama: 0.1 and svm__kernel: rbf with 62% accuracy
        # After adding the new properties: session_duration_ms, hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms_avg, down_down_duration_ms_avg, up_down_duration_ms_avg, total_unique_keys_used, total_keys_pressed and characters_per_second, and hot encodings was false, the best params are: svm__C: 100, svm__gama: 0.01 and svm__kernel: rbf with 87% accuracy, 0.0068 FAR, 0.13 FRR and 0.0402 EER with 19.60 threshold
        #   after setting one hot encoding to true, the best params are: svm__C: 100, svm__gama: 0.01 and svm__kernel: rbf with 89% accuracy, 0.0057 FAR, 0.11 FRR and 0.0470 EER with 19.50 threshold
    else:
        print(f"{classifier_name} is not implemented.")

    accuracy, far, frr, mean_eer, mean_threshold, cv = get_classifier_performance(classifier=classifier,
                                                                                  X_scaled=X_scaled, y=y, y_test=y_test,
                                                                                  y_pred=y_pred, y_scores=y_scores)

    if print_results:
        print_classifier_performance(classifier_name=classifier_name, y_test=y_test, y_pred=y_pred, accuracy=accuracy,
                                     far=far, frr=frr, mean_eer=mean_eer, mean_threshold=mean_threshold, cv=cv)

    return accuracy, far, frr, mean_eer, mean_threshold, cv
