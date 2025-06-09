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
import ast


def parse_np_int_list(s):
    if pd.isna(s):  # Handle NaNs
        return []
    try:
        s_clean = s.replace("np.int64", "")
        return [int(x) for x in ast.literal_eval(s_clean)]
    except (ValueError, SyntaxError):
        return []


def key_press_event_analysis(key_press_event_df, classifier_name):
    if key_press_event_df is None:
        key_press_event_df = pd.read_csv("..\\data\\key_press_event_features.csv")

    # Drop the auto-generated index
    key_press_event_df = key_press_event_df.drop(columns=["Unnamed: 0"])

    # When read from CSV, start_timestamps type is string
    key_press_event_df["start_timestamps"] = pd.to_numeric(key_press_event_df["start_timestamps"], errors="coerce")
    key_press_event_df["start_timestamps"] = key_press_event_df["start_timestamps"].astype("int64")

    # Predicted value will be user_id
    y = key_press_event_df["user_id"]
    X = key_press_event_df.drop(
        columns=["user_id", "activity_id", "session_number", "start_timestamps", "key_ids", "key_ids_occurrences"]
    )

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    y_pred = None
    classifier = None
    if classifier_name == "k-NN":
        # Without activity_id, session_number, start_timestamps, key_ids and key_ids_occurrences, the best k value was 1 with 62.82% accuracy in a cross validation scenario
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

        classifier = knn

        # Without activity_id, session_number, start_timestamps, key_ids and key_ids_occurrences, the best k value was 1 with 62% accuracy in a one shot test accuracy

    elif classifier_name == "Random Forest":
        best_k = 0

        # After k=100, the accuracy is relatively constant at around 59.94%
        #   but k=201 showed the best accuracy of 62.57%
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

            # After 1 hour of executing, the best params are: svm__C: 1000, svm__gama: 0.1 and svm__kernel: rbf with 62% accuracy
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

        classifier = svm
    else:
        print(f"{classifier_name} is not implemented.")

    print(f"{classifier_name} Classification Report:")
    print(classification_report(y_test, y_pred))

    accuracy = accuracy_score(y_test, y_pred)
    print("Accuracy:", accuracy)

    cv = cross_val_score(classifier, X_scaled, y, cv=5)
    print(f"{classifier_name} 5-fold CV accuracy:", np.round(cv.mean(), decimals=4))
