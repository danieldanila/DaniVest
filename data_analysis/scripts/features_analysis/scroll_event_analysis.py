import math

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.metrics import classification_report, accuracy_score
import matplotlib.pyplot as plt
import seaborn as sns

from scripts.algorithms.equal_error_rate import compute_multiclass_eer
from scripts.algorithms.false_acceptance_rate import calculate_overall_far
from scripts.algorithms.false_rejection_rate import calculate_overall_frr


def scroll_event_analysis(scroll_event_df, classifier_name):
    if scroll_event_df is None:
        scroll_event_df = pd.read_csv("..\\data\\scroll_event_features.csv")

    # Drop the auto-generated index
    scroll_event_df = scroll_event_df.drop(columns=["Unnamed: 0"])

    # When read from CSV, start_timestamps type is string
    scroll_event_df["start_timestamps"] = pd.to_numeric(scroll_event_df["start_timestamps"], errors="coerce")
    scroll_event_df["start_timestamps"] = scroll_event_df["start_timestamps"].astype("int64")

    # Predicted value will be user_id
    y = scroll_event_df["user_id"]
    X = scroll_event_df.drop(
        columns=["user_id", "activity_id", "session_number", "start_timestamps", "scroll_id"]
    )

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    y_pred = None
    classifier = None
    y_scores = None
    if classifier_name == "k-NN":
        # Without activity_id, session_number, start_timestamps and scroll_id, the best k value was 15 with 45.94% accuracy in a cross validation scenario
        best_k = 0

        if best_k == 0:
            k_max = math.floor(math.sqrt(len(X_train_scaled)) / 2)
            k_values = range(1, k_max)
            cv_scores = []

            for k in k_values:
                knn = KNeighborsClassifier(n_neighbors=k)
                scores = cross_val_score(knn, X_train_scaled, y_train, cv=5, scoring="accuracy")
                cv_scores.append(scores.mean())

            best_index = np.argmax(cv_scores)
            best_k = k_values[best_index]
            best_score = cv_scores[best_index]
            print(f"Best k: {best_k} with accuracy: {best_score}")

        knn = KNeighborsClassifier(n_neighbors=best_k)
        knn.fit(X_train_scaled, y_train)

        y_pred = knn.predict(X_test_scaled)
        y_scores = knn.predict_proba(X_test_scaled)

        classifier = knn

        # Without activity_id, session_number, start_timestamps and scroll_id, the best k value was 15 with 46.16% accuracy in a one shot test accuracy
        # After adding the new properties: hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms, down_down_duration_ms, up_down_duration_ms, start_quadrant, end_quadrant, scroll_length_euclidean_distance, scroll_angle, direction, magnitude_speed and hot encodings was true, the best k = 1 with 81.13% accuracy, 0.0094 FAR, 0.1867 FRR and 0.1072 EER with 1.0 threshold
        #   after turning off the hot encodings, the best k = 1 with 83.56% accuracy, 0.0082 FAR, 0.1643 FRR and 0.0947 EER with 1.0 threshold
    elif classifier_name == "Random Forest":
        best_k = 0

        # After k=100, the accuracy is relatively constant at around 52%
        #   but k=151 showed the best accuracy of 52.07%
        # After adding the new properties: hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms, down_down_duration_ms, up_down_duration_ms, start_quadrant, end_quadrant, scroll_length_euclidean_distance, scroll_angle, direction, magnitude_speed and hot encodings was true, the best k = 201 with 90.04% accuracy, 0.0053 FAR, 0.0995 FRR and 0.0223 EER with 0.1850 threshold
        #   after turning off the hot encodings, the best k = 201 with 90.05% accuracy, 0.0050 FAR, 0.0946 FRR and 0.0214 EER with 0.1850 threshold
        if best_k == 0:
            k_values = list(range(1, 202, 50))
            cv_scores = []

            for k in k_values:
                rfc = RandomForestClassifier(n_estimators=k)
                scores = cross_val_score(rfc, X_train, y_train, cv=5, scoring="accuracy")
                cv_scores.append(scores.mean())

            best_index = np.argmax(cv_scores)
            best_k = k_values[best_index]
            best_score = cv_scores[best_index]
            print(f"Best k: {best_k} with accuracy: {best_score}")

            plt.plot(k_values, cv_scores)
            plt.xlabel('Value of n_estimators for Random Forest Classifier')
            plt.ylabel('Testing Accuracy')
            plt.show()

        rf = RandomForestClassifier(n_estimators=best_k, random_state=42)
        rf.fit(X_train, y_train)

        y_pred = rf.predict(X_test)
        y_scores = rf.predict_proba(X_test)

        classifier = rf

        importances = rf.feature_importances_
        feature_names = X.columns

        plt.figure(figsize=(10, 6))
        sns.barplot(x=importances, y=feature_names)
        plt.title("Random Forest Feature Importances")
        plt.xlabel("Importance")
        plt.ylabel("Feature")
        plt.tight_layout()
        plt.show()

    elif classifier_name == "SVM":
        best_c = 0
        best_gamma = 0
        best_kernel = "rbf"

        if best_c == 0 and best_gamma == 0:
            svm = SVC()

            pipeline = Pipeline([
                ("scaler", scaler),
                ("svm", svm)
            ])

            # After 2 hours of executing, the best params are: svm__C: 1000, svm__gama: 0.1 and svm__kernel: rbf with 52.85% accuracy
            # After adding the new properties: hour_sin, hour_cos, dow_sin, dow_cos, month_sin, month_cos, is_weekend, part_of_day, down_up_duration_ms, down_down_duration_ms, up_down_duration_ms, start_quadrant, end_quadrant, scroll_length_euclidean_distance, scroll_angle, direction, magnitude_speed and hot encodings was true, the best params are: svm__C: 10, svm__gama: 0.01 and svm__kernel: rbf with 83.87% accuracy, 0.0085 FAR, 0.1612 FRR and 0.0505 EER with 18.79 threshold
            #   after turning off the hot encodings, the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 88.87% accuracy, 0.0058 FAR, 0.1126 FRR and 0.0386 EER with 19.03 threshold
            param_grid = {"svm__C": [10, 100, 1000],
                              "svm__gamma": [0.01, 0.1, 1.0, 10.0],
                              "svm__kernel": ["rbf"]}


            grid = GridSearchCV(pipeline, param_grid, cv=5, scoring="accuracy", n_jobs=-1)

            grid.fit(X, y)

            best_c = grid.best_params_['svm__C']
            best_gamma = grid.best_params_['svm__gamma']
            best_kernel = grid.best_params_['svm__kernel']

            print("Best parameters:", grid.best_params_)
            print("Best cross-val accuracy:", grid.best_score_)

        svm = SVC(kernel=best_kernel, C=best_c, gamma=best_gamma)
        svm.fit(X_train_scaled, y_train)

        y_pred = svm.predict(X_test_scaled)
        y_scores = svm.decision_function(X_test_scaled)

        classifier = svm
    else:
        print(f"{classifier_name} is not implemented.")

    print(f"{classifier_name} Classification Report:")
    print(classification_report(y_test, y_pred))

    accuracy = accuracy_score(y_test, y_pred)
    print("Accuracy:", accuracy)
    far = calculate_overall_far(y_true=y_test, y_pred=y_pred)
    print("FAR (False Acceptance Rate):", far)
    frr = calculate_overall_frr(y_true=y_test, y_pred=y_pred)
    print("FRR (False Rejection Rate):", frr)
    mean_eer, mean_threshold = compute_multiclass_eer(y_test, y_scores)
    print(f"EER (Equal Error Rate): {mean_eer} with EER threshold: {mean_threshold}")

    cv = cross_val_score(classifier, X_scaled, y, cv=5)
    print(f"{classifier_name} 5-fold CV accuracy:", np.round(cv.mean(), decimals=4))
