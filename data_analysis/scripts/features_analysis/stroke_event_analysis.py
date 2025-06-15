from scripts.Utils.classifiers_reports import print_classifier_performance
from scripts.Utils.prepare_analysis_data import prepare_analysis_data
from scripts.algorithms.k_nearest_neighbors import k_nearest_neighbors
from scripts.algorithms.random_forest import random_forest_classifier
from scripts.algorithms.support_vector_machine import support_vector_machine


def stroke_event_analysis(stroke_event_df, classifier_name):
    # Drop Test 8
    # columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps", "start_size",
    #                                "end_size", "speed_x", "speed_y"]

    # Drop Test 9
    # columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps", "start_size",
    #                                "end_size", "speed_x", "speed_y", "phone_orientation", "start_quadrant",
    #                                "end_quadrant", "direction"]

    # Drop Test 10
    # columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps", "start_size",
    #                                "end_size", "speed_x", "speed_y", "phone_orientation", "start_quadrant",
    #                                "end_quadrant", "direction", "start_x", "start_y", "end_x", "end_y",
    #                                "X_coord_distance", "Y_coord_distance"]

    # Drop Test 11
    # columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps", "start_size",
    #                                "end_size", "speed_x", "speed_y", "phone_orientation", "start_quadrant",
    #                                "end_quadrant", "direction", "X_coord_distance", "Y_coord_distance"]

    # Drop Test 12 + 13 (with new properties: one hot encoding also for phone_orientation + part_of_day, hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend)
    columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "start_timestamps"]

    # Drop Test 14
    # columns_names_to_drop_array = ["user_id", "activity_id", "session_number", "hour_sin", "hour_cos", "dow_sin",
    #                                "dow_cos", "month_sin", "month_cos", "is_weekend", "part_of_day"]

    X, y, X_train, X_test, y_train, y_test, X_scaled, X_train_scaled, X_test_scaled = prepare_analysis_data(
        df=stroke_event_df, csv_file_path="..\\data\\stroke_event_features.csv",
        column_name_to_predict="user_id", columns_names_to_drop_array=columns_names_to_drop_array)

    y_pred = None
    y_scores = None
    classifier = None
    if classifier_name == "k-NN":
        best_k = 0
        y_pred, y_scores, classifier = k_nearest_neighbors(X_train_scaled=X_train_scaled, X_test_scaled=X_test_scaled,
                                                           y_train=y_train, best_k=best_k)

        # Without activity_id, session_number and start_timestamps, the best k value was 1 with 46% accuracy in a one shot test accuracy
        # After changing how data is processed and adding the new properties down_down_duration_ms and up_down_duration_ms, the k = 20 with 42.78% accuracy
        # After adding the new properties X_coord_distance and Y_coord_distance, the best k = 20 with 44.65% accuracy
        # After adding the new properties start_quadrant, end_quadrant and direction, the best k = 13 with 43.14% accuracy
        # After transforming the properties start_quadrant, end_quadrant and direction into one hot encodings, the best k = 12 with 42.07% accuracy
        # After adding magnitude_speed and turning off the one hot encodings, the best k = 16 with 42.74% accuracy, 0.03 FAR, 0.57 FRR and 0.20 EER with 0.0922 threshold
        # After adding magnitude_speed and turning on the one hot encodings, the best k = 12 with 42.25% accuracy, 0.0370 FAR, 0.5774 FRR and 0.2180 EER with 0.1031 threshold
        # After adding contact_size_avg, stroke_length, stroke_angle and removing start_size, end_size and speed_x and speed_y, the best k = 11 with 43.12% accuracy, 0.0365 FAR, 0.5687 FRR and 0.2104 EER with 0.1082 threshold
        #   after also removing  "phone_orientation", "start_quadrant", "end_quadrant" and "direction", the best k = 11 with 43.83% accuracy, 0.0359 FAR, 0.5616 FRR and 0.2104 EER with 0.1125 threshold
        #   after also removing  "start_x", "start_y", "end_x", "end_y", "X_coord_distance" and "Y_coord_distance", the best k = 30 with 30.09% accuracy, 0.0463 FAR, 0.6990 FRR and 0.2690 EER with 0.0761 threshold
        #   after re-adding "start_x", "start_y", "end_x" and "end_y", the best k = 17 with 43.53% accuracy, 0.0364 FAR, 0.5646 FRR and 0.2077 EER with 0.0896 threshold
        # After dropping only activity_id, session_number and start_timestamps, the best k = 15 with 43.10% accuracy, 0.0365 FAR, 0.5689 FRR and 0.2111 EER with 0.0952 threshold
        #   after adding new properties: part_of_day, hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend and activated one hot encodings (for Direction, Start_Quadrant, End_Quadrant, Phone_orientation, Part_Of_Day), the best k = 1 with 76.05% accuracy, 0.0134 FAR, 0.2394 FRR and 0.1453 EER with 1.0 threshold
        #   after running the same setup except one hot encoding was False, the best k = 1 with 79.64% accuracy, 0.0112 FAR, 0.2035 FRR and 0.1271 EER with 1.0 threshold
        #   after dropping all time related properties and re-adding start_timestamp, the best k = 7 with 61.33% accuracy, 0.0245 FAR, 0.3866 FRR and 0.1298 EER with 0.1564 threshold
    elif classifier_name == "Random Forest":
        best_n_estimators = 201
        y_pred, y_scores, classifier = random_forest_classifier(X=X, X_train=X_train, X_test=X_test, y_train=y_train,
                                                                best_n_estimators=best_n_estimators)

        # After best_n_estimators=100, the accuracy is relatively constant at around 52%
        #   but best_n_estimators=201 showed the best accuracy of 50.75%
        # After changing how data is processed and adding the new properties down_down_duration_ms and up_down_duration_ms, the best best_n_estimators = 201 with 54.02% accuracy
        # After adding the new properties X_coord_distance and Y_coord_distance, the best best_n_estimators = 201 with 55.53% accuracy
        # After adding the new properties start_quadrant, end_quadrant and direction, the best best_n_estimators = 201 with 55.10% accuracy
        # After transforming the properties start_quadrant, end_quadrant and direction into one hot encodings, the best best_n_estimators = 201 with 55.20% accuracy
        # After adding magnitude_speed and turning off the one hot encodings, the best best_n_estimators = 201 with 55.63% accuracy, 0.02 FAR, 0.44 FRR and 0.15 EER with 0.0670 threshold
        # After adding magnitude_speed and turning on the one hot encodings, the best best_n_estimators = 201 with 56.08% accuracy, 0.0289 FAR, 0.4391 FRR and 0.1522 EER with 0.0682 threshold
        # After adding contact_size_avg, stroke_length, stroke_angle and removing start_size, end_size and speed_x and speed_y, the best best_n_estimators = 151 with 54.71% accuracy, 0.0295 FAR, 0.4528 FRR and 0.1579 EER with 0.0678 threshold
        #   after also removing  "phone_orientation", "start_quadrant", "end_quadrant" and "direction", the best best_n_estimators = 201 with 53.98% accuracy, 0.0299 FAR, 0.4601 FRR and 0.1636 EER with 0.0660 threshold
        #   after also removing  "start_x", "start_y", "end_x", "end_y", "X_coord_distance" and "Y_coord_distance", the best best_n_estimators = 201 with 40.12% accuracy, 0.0386 FAR, 0.5987 FRR and 0.2209 EER with 0.0566 threshold
        #   after re-adding "start_x", "start_y", "end_x" and "end_y", the best best_n_estimators = 201 with 53.03% accuracy, 0.0306 FAR, 0.4696 FRR and 0.1606 EER with 0.0660 threshold
        # After dropping only activity_id, session_number and start_timestamps, the best best_n_estimators = 201 with 55.81% accuracy, 0.0289 FAR, 0.4418 FRR and 0.1506 EER with 0.0684 threshold
        #   after adding new properties: part_of_day, hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend and activated one hot encodings (for Direction, Start_Quadrant, End_Quadrant, Phone_orientation, Part_Of_Day), the best best_n_estimators = 201 with 87.77% accuracy, 0.0074 FAR, 0.1229 FRR and 0.0272 EER with 0.1802 threshold
        #   after running the same setup except one hot encoding was False, the best best_n_estimators = 201 with 87.70% accuracy, 0.0076 FAR, 0.1239 FRR and 0.0260 EER with 0.1795 threshold
        #   after dropping all time related properties and re-adding start_timestamp, the best best_n_estimators = 201 with 90.57% accuracy, 0.0056 FAR, 0.0942 FRR and 0.0248 EER with 0.1425 threshold
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

        # After 1 hour of executing, the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 50.75% accuracy
        # After changing how data is processed and adding the new properties down_down_duration_ms and up_down_duration_ms, the best params are: svm__C: 100, svm__gama: 0.1 and svm__kernel: rbf with 47.89% accuracy
        # After adding the new properties X_coord_distance and Y_coord_distance, the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 48.99% accuracy
        # After adding the new properties start_quadrant, end_quadrant and direction, the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 49.38% accuracy
        # After transforming the properties start_quadrant, end_quadrant and direction into one hot encodings, the best params are: svm__C: 1000, svm__gama: 0.01 and svm__kernel: rbf with 47.59% accuracy
        # After adding magnitude_speed and turning off the one hot encodings,the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 49.32% accuracy, 0.03 FAR, 0.50 FRR and 0.18 EER with 15.2321 threshold
        # After adding magnitude_speed and turning on the one hot encodings,the best params are: svm__C: 1000, svm__gama: 0.01 and svm__kernel: rbf with 47.81% accuracy, 0.0330 FAR, 0.5218 FRR and 0.19156 EER with 14.9110 threshold
        # After adding contact_size_avg, stroke_length, stroke_angle and removing start_size, end_size and speed_x and speed_y, the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 48.16% accuracy, 0.0329 FAR, 0.5218 FRR and 0.1897 EER with 15.3758 threshold
        #   after also removing  "phone_orientation", "start_quadrant", "end_quadrant" and "direction", the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 47.33% accuracy, 0.0338 FAR, 0.5266 FRR and 0.1964 EER with 15.2814 threshold
        #   after also removing  "start_x", "start_y", "end_x", "end_y", "X_coord_distance" and "Y_coord_distance", the best params are: svm__C: 1000, svm__gama: 0.1 and svm__kernel: rbf with 34.40% accuracy, 0.0436 FAR, 0.6598 FRR and 0.2498 EER with 14.0028 threshold
        #   after re-adding "start_x", "start_y", "end_x" and "end_y", the best params are: svm__C: 100, svm__gama: 0.1 and svm__kernel: rbf with 47.93% accuracy, 0.0326 FAR, 0.5206 FRR and 0.1986 EER with 14.9073 threshold
        # After dropping only activity_id, session_number and start_timestamps, the best params are: svm__C: 1000, svm__gama: 0.01 and svm__kernel: rbf with 49.23% accuracy, 0.0318 FAR, 0.5076 FRR and 0.1870 EER with 15.2906 threshold
        #   after adding new properties: part_of_day, hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend and activated one hot encodings (for Direction, Start_Quadrant, End_Quadrant, Phone_orientation, Part_Of_Day), the best params are: svm__C: 10, svm__gama: 0.01 and svm__kernel: rbf with 83.01% accuracy, 0.0103 FAR, 0.1698 FRR and 0.0551 EER with 18.6508 threshold
        #   after running the same setup except one hot encoding was False, the best params are: svm__C: 10, svm__gama: 0.01 and svm__kernel: rbf with 82.89% accuracy, 0.0104 FAR, 0.1710 FRR and 0.0553 EER with 18.556 threshold
        #   after dropping all time related properties and re-adding start_timestamp, the best params are: svm__C: 100, svm__gama: 0.01 and svm__kernel: rbf with 86.04% accuracy, 0.0077 FAR, 0.1395 FRR and 0.0469 EER with 19.0322 threshold
    else:
        print(f"{classifier_name} is not implemented.")

    print_classifier_performance(classifier_name=classifier_name, classifier=classifier, X_scaled=X_scaled, y=y,
                                 y_test=y_test, y_pred=y_pred, y_scores=y_scores)
