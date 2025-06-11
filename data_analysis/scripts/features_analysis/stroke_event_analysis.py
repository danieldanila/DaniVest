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


def stroke_event_analysis(stroke_event_df, classifier_name):
    if stroke_event_df is None:
        stroke_event_df = pd.read_csv("..\\data\\stroke_event_features.csv")

    # Drop the auto-generated index
    stroke_event_df = stroke_event_df.drop(columns=["Unnamed: 0"])

    # When read from CSV, start_timestamps type is string
    stroke_event_df["start_timestamps"] = pd.to_numeric(stroke_event_df["start_timestamps"], errors="coerce")
    stroke_event_df["start_timestamps"] = stroke_event_df["start_timestamps"].astype("int64")

    # Predicted value will be user_id
    y = stroke_event_df["user_id"]
    X = stroke_event_df.drop(
        columns=["user_id", "activity_id", "session_number", "start_timestamps"]
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
        # Without activity_id, session_number and start_timestamps, the best k value was 1 with 43.48% accuracy in a cross validation scenario
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

        # Without activity_id, session_number and start_timestamps, the best k value was 1 with 46% accuracy in a one shot test accuracy
        # After changing how data is processed and adding the new properties down_down_duration_ms and up_down_duration_ms, the k = 20 with 42.78% accuracy
        # After adding the new properties X_coord_distance and Y_coord_distance, the best k = 20 with 44.65% accuracy
        # After adding the new properties start_quadrant, end_quadrant and direction, the best k = 13 with 43.14% accuracy
        # After transforming the properties start_quadrant, end_quadrant and direction into one hot encodings, the best k = 12 with 42.07% accuracy
        # After adding magnitude_speed and turning off the one hot encodings, the best k = 16 with 42.74% accuracy, 0.03 FAR, 0.57 FRR and 0.20 EER with 0.0922 threshold
        # After adding magnitude_speed and turning on the one hot encodings, the best k = 12 with 42.25% accuracy, 0.0370 FAR, 0.5774 FRR and 0.2180 EER with 0.1031 threshold
    elif classifier_name == "Random Forest":
        best_k = 0

        # After k=100, the accuracy is relatively constant at around 52%
        #   but k=201 showed the best accuracy of 50.75%
        # After changing how data is processed and adding the new properties down_down_duration_ms and up_down_duration_ms, the best k = 201 with 54.02% accuracy
        # After adding the new properties X_coord_distance and Y_coord_distance, the best k = 201 with 55.53% accuracy
        # After adding the new properties start_quadrant, end_quadrant and direction, the best k = 201 with 55.10% accuracy
        # After transforming the properties start_quadrant, end_quadrant and direction into one hot encodings, the best k = 201 with 55.20% accuracy
        # After adding magnitude_speed and turning off the one hot encodings, the best k = 201 with 55.63% accuracy, 0.02 FAR, 0.44 FRR and 0.15 EER with 0.0670 threshold
        # After adding magnitude_speed and turning on the one hot encodings, the best k = 201 with 56.08% accuracy, 0.0289 FAR, 0.4391 FRR and 0.1522 EER with 0.0682 threshold
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

            # After 1 hour of executing, the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 50.75% accuracy
            # After changing how data is processed and adding the new properties down_down_duration_ms and up_down_duration_ms, the best params are: svm__C: 100, svm__gama: 0.1 and svm__kernel: rbf with 47.89% accuracy
            # After adding the new properties X_coord_distance and Y_coord_distance, the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 48.99% accuracy
            # After adding the new properties start_quadrant, end_quadrant and direction, the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 49.38% accuracy
            # After transforming the properties start_quadrant, end_quadrant and direction into one hot encodings, the best params are: svm__C: 1000, svm__gama: 0.01 and svm__kernel: rbf with 47.59% accuracy
            # After adding magnitude_speed and turning off the one hot encodings,the best params are: svm__C: 10, svm__gama: 0.1 and svm__kernel: rbf with 49.32% accuracy, 0.03 FAR, 0.50 FRR and 0.18 EER with 15.2321 threshold
            # After adding magnitude_speed and turning on the one hot encodings,the best params are: svm__C: 1000, svm__gama: 0.01 and svm__kernel: rbf with 47.81% accuracy, 0.0330 FAR, 0.5218 FRR and 0.19156 EER with 14.9110 threshold
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
