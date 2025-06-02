import math

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, accuracy_score
import matplotlib.pyplot as plt
import seaborn as sns


def touch_event_analysis(touch_event_df, classifier_name):
    if touch_event_df is None:
        touch_event_df = pd.read_csv("..\\data\\touch_event_features.csv")

    # Drop the auto-generated index
    touch_event_df = touch_event_df.drop(columns=['Unnamed: 0'])

    # When read from CSV, start_timestamps type is string
    touch_event_df['start_timestamps'] = pd.to_numeric(touch_event_df['start_timestamps'], errors='coerce')
    touch_event_df['start_timestamps'] = touch_event_df['start_timestamps'].astype('int64')

    # Predicted value will be user_id
    y = touch_event_df["user_id"]
    X = touch_event_df.drop(columns=["user_id", "activity_id", "session_number", "start_timestamps"])

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    X_train, X_test, y_train, y_test = train_test_split(X_scaled, y, test_size=0.2, random_state=42, stratify=y)

    y_pred = None
    classifier = None
    if classifier_name == "k-NN":
        # With activity_id and session_number, the best k value was 10 with 75% accuracy in a cross validation scenario
        # Without activity_id and session_number but with start_timestamps, the best k value was 5 with 87% accuracy in a cross validation scenario
        # Without activity_id, session_number and start_timestamps, the best k value was 5 with 87% accuracy in a cross validation scenario
        # Without activity_id, session_number and start_timestamps, the best k value was 27 with 59% accuracy in a cross validation scenario
        best_k = 27

        if best_k == 0:
            k_max = math.floor(math.sqrt(len(X_train)) / 2)
            k_values = range(1, k_max)
            cv_scores = []

            for k in k_values:
                knn = KNeighborsClassifier(n_neighbors=k)
                scores = cross_val_score(knn, X_scaled, y, cv=5, scoring='accuracy')
                cv_scores.append(scores.mean())

            best_k = k_values[np.argmax(cv_scores)]
            print(f"Best k: {best_k} with accuracy: {max(cv_scores)}")

        knn = KNeighborsClassifier(n_neighbors=best_k)
        knn.fit(X_train, y_train)

        y_pred = knn.predict(X_test)

        classifier = knn

        # With activity_id and session_number, the best k value was 10 with 93% accuracy in a one shot test accuracy
        # Without activity_id and session_number but with start_timestamp, the best k value was 5 with 91% accuracy in a one shot test accuracy
        # Without activity_id, session_number and start_timestamps, the best k value was 5 with 91% accuracy in a one shot test accuracy
        # Without activity_id, session_number and start_timestamps, the best k value was 27 with 63% accuracy in a one shot test accuracy

    elif classifier_name == "Random Forest":
        k = 200

        # After k=100, the accuracy is relatively constant at around 68%
        # but k=190->200 showed the best accuracy of 68.4%+
        if k == 0:
            scores = []
            for k in range(1, 200):
                rfc = RandomForestClassifier(n_estimators=k)
                rfc.fit(X_train, y_train)
                y_pred = rfc.predict(X_test)
                scores.append(accuracy_score(y_test, y_pred))

            plt.plot(range(1, 200), scores)
            plt.xlabel('Value of n_estimators for Random Forest Classifier')
            plt.ylabel('Testing Accuracy')
            plt.show()

        rf = RandomForestClassifier(n_estimators=k, random_state=42)
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
    else:
        print(f"{classifier_name} is not implemented.")

    print(f"{classifier_name} Classification Report:")
    print(classification_report(y_test, y_pred))

    accuracy = accuracy_score(y_test, y_pred)
    print("Accuracy:", accuracy)

    cv = cross_val_score(classifier, X_scaled, y, cv=5)
    print(f"{classifier_name} 5-fold CV accuracy:", np.round(cv.mean(), decimals=4))
