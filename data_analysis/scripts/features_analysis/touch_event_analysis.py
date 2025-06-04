import math

import pandas as pd
import numpy as np
from sklearn.impute import SimpleImputer
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
from sklearn.metrics import classification_report, accuracy_score
import matplotlib.pyplot as plt
import seaborn as sns


def touch_event_analysis(touch_event_df, classifier_name):
    if touch_event_df is None:
        touch_event_df = pd.read_csv("..\\data\\touch_event_features.csv")

    # Drop the auto-generated index
    touch_event_df = touch_event_df.drop(columns=["Unnamed: 0"])

    # When read from CSV, start_timestamps type is string
    touch_event_df["start_timestamps"] = pd.to_numeric(touch_event_df["start_timestamps"], errors="coerce")
    touch_event_df["start_timestamps"] = touch_event_df["start_timestamps"].astype("int64")

    # In the scenarios where only one finger is used, replace 0 values for second finger with the mean
    mask = touch_event_df["scenario"] != 2
    columns = ["move_actions_second", "X_coord_second_avg", "Y_coord_second_avg", "Contact_size_second_avg",
               "X_coord_distance_avg", "Y_coord_distance_avg"]
    touch_event_df.loc[mask, columns] = np.nan
    imputer = SimpleImputer(strategy='mean')
    touch_event_df[columns] = imputer.fit_transform(touch_event_df[columns])

    # Predicted value will be user_id
    y = touch_event_df["user_id"]
    X = touch_event_df.drop(
        columns=["user_id", "activity_id", "session_number", "start_timestamps", "move_actions", "X_coord_avg",
                 "Y_coord_avg", "Contact_size_avg"])

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    y_pred = None
    classifier = None
    if classifier_name == "k-NN":
        # With activity_id and session_number, the best k value was 10 with 75% accuracy in a cross validation scenario
        # Without activity_id and session_number but with start_timestamps, the best k value was 5 with 87% accuracy in a cross validation scenario
        # Without activity_id, session_number and start_timestamps, the best k value was 5 with 87% accuracy in a cross validation scenario
        # Without activity_id, session_number and start_timestamps, the best k value was 27 with 59% accuracy in a cross validation scenario
        best_k = 20

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

        # With activity_id and session_number, the best k value was 10 with 93% accuracy in a one shot test accuracy
        # Without activity_id and session_number but with start_timestamp, the best k value was 5 with 91% accuracy in a one shot test accuracy
        # Without activity_id, session_number and start_timestamps, the best k value was 5 with 91% accuracy in a one shot test accuracy
        # Without activity_id, session_number and start_timestamps, the best k value was 27 with 63% accuracy in a one shot test accuracy
        # After adding the new properties down_down_duration_ms and up_down_duration_ms, no change in accuracy reported for k-NN classifier (best k = 21)
        # After adding the new properties move_actions, X_coord_avg, Y_coord_avg, Contact_size_avg and dropping the properties specific to the first/second touch,
        #   the accuracy dropped to 58% (k = 21)
        # After adding the new X_coord_distance_avg and Y_coord_distance_avg, the accuracy increased by 1% to 64% (k = 20)

    elif classifier_name == "Random Forest":
        best_k = 151

        # After k=100, the accuracy is relatively constant at around 68%
        #   but k=190->200 showed the best accuracy of 68.4%+
        # After adding the new properties down_down_duration_ms and up_down_duration_ms, an increase of 2% in accuracy
        #   was recorded, from 68% to 70%
        # After adding the new properties move_actions, X_coord_avg, Y_coord_avg, Contact_size_avg and dropping the properties specific to the first/second touch,
        #   the accuracy dropped to 64%
        # After adding the new X_coord_distance_avg and Y_coord_distance_avg, the accuracy remained at 70.41% (k = 151)
        if best_k == 0:
            k_values = list(range(1, 201, 50))
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

            # After 7 hours of executing, the best params are: svm__C: 100, svm__gama: 0.1 and svm__kernel: rbf with 63.93% accuracy
            param_grid_old = {"svm__C": [0.001, 0.01, 0.1, 1, 10, 100],
                           "svm__gamma": [0.0001, 0.001, 0.01, 0.1, 1.0],
                           "svm__kernel": ["linear", "rbf"]}

            # After 1.5 hours of executing, the best params are: svm__C: 1000, svm__gama: 1.0 and svm__kernel: rbf with 66.39% accuracy
            param_grid_old = {"svm__C": [10, 100, 1000],
                              "svm__gamma": [0.01, 0.1, 1.0, 10.0],
                              "svm__kernel": ["rbf"]}

            # Executed for more than 3 hours, left it for the moment
            param_grid = {"svm__C": [1000, 10000, 100000],
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
