from scripts.Utils.classifiers_reports import print_classifier_performance, get_classifier_performance
from scripts.Utils.prepare_analysis_data import prepare_analysis_data
from scripts.algorithms.k_nearest_neighbors import k_nearest_neighbors
from scripts.algorithms.random_forest import random_forest_classifier
from scripts.algorithms.support_vector_machine import support_vector_machine


def scroll_event_analysis(scroll_event_df, classifier_name, print_results=False):
    columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps", "scroll_id"]

    X, y, X_train, X_test, y_train, y_test, X_scaled, X_train_scaled, X_test_scaled = prepare_analysis_data(
        df=scroll_event_df, feature_name="scroll_event",
        csv_file_path="..\\data\\features\\scroll_event_features.csv",
        column_name_to_predict="user_id", columns_names_to_drop_array=columns_names_to_drop_array)

    y_pred = None
    classifier = None
    y_scores = None
    if classifier_name == "k-NN":
        best_k = 0
        y_pred, y_scores, classifier = k_nearest_neighbors(X_train_scaled=X_train_scaled, X_test_scaled=X_test_scaled,
                                                           y_train=y_train, best_k=best_k,
                                                           feature_name="scroll_event")

        # 1. Without activity_id, session_number, start_timestamps and scroll_id, the best k value was 15 with 46.16% accuracy in a one shot test accuracy
        # 2. After adding the new properties: hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms, down_down_duration_ms, up_down_duration_ms, start_quadrant, end_quadrant, scroll_length_euclidean_distance, scroll_angle, direction, magnitude_speed and hot encodings was true, the best k = 1 with 81.13% accuracy, 0.0094 FAR, 0.1867 FRR and 0.1072 EER with 1.0 threshold
        # 3.  after turning off the hot encodings, the best k = 1 with 83.56% accuracy, 0.0082 FAR, 0.1643 FRR and 0.0947 EER with 1.0 threshold
    elif classifier_name == "Random Forest":
        best_n_estimators = 201
        y_pred, y_scores, classifier = random_forest_classifier(X=X, X_train=X_train, X_test=X_test, y_train=y_train,
                                                                best_n_estimators=best_n_estimators,
                                                                feature_name="scroll_event")

        # 1. After k=100, the accuracy is relatively constant at around 52%
        #   but k=151 showed the best accuracy of 52.07%
        # 2. After adding the new properties: hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms, down_down_duration_ms, up_down_duration_ms, start_quadrant, end_quadrant, scroll_length_euclidean_distance, scroll_angle, direction, magnitude_speed and hot encodings was true, the best best_n_estimators = 201 with 90.04% accuracy, 0.0053 FAR, 0.0995 FRR and 0.0223 EER with 0.1850 threshold
        # 3.  after turning off the hot encodings, the best best_n_estimators = 201 with 90.05% accuracy, 0.0050 FAR, 0.0946 FRR and 0.0214 EER with 0.1850 threshold
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
                                                              best_gamma=best_gamma, best_kernel=best_kernel,
                                                              feature_name="scroll_event")

        # 1. After 2 hours of executing, the best params are: svm__C: 1000, svm__gama: 0.1 and svm__kernel: rbf with 52.85% accuracy
        # 2. After adding the new properties: hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms, down_down_duration_ms, up_down_duration_ms, start_quadrant, end_quadrant, scroll_length_euclidean_distance, scroll_angle, direction, magnitude_speed and hot encodings was true, the best params are: svm__C: 10, svm__gama: 0.01 and svm__kernel: rbf with 83.87% accuracy, 0.0085 FAR, 0.1612 FRR and 0.0505 EER with 18.79 threshold
        # 3.  after turning off the hot encodings, the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 88.87% accuracy, 0.0058 FAR, 0.1126 FRR and 0.0386 EER with 19.03 threshold
    else:
        print(f"{classifier_name} is not implemented.")

    accuracy, far, frr, mean_eer, mean_threshold, cv = get_classifier_performance(classifier=classifier,
                                                                                  X_scaled=X_scaled, y=y, y_test=y_test,
                                                                                  y_pred=y_pred, y_scores=y_scores)

    if print_results:
        print_classifier_performance(classifier_name=classifier_name, y_test=y_test, y_pred=y_pred, accuracy=accuracy,
                                     far=far, frr=frr, mean_eer=mean_eer, mean_threshold=mean_threshold, cv=cv)

    return accuracy, far, frr, mean_eer, mean_threshold, cv
