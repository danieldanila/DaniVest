import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score


def random_forest_classifier(X, X_train, X_test, y_train, best_k=0):
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
        print(f"Random Forest 5-fold, best k in cross validation: {best_k} with accuracy: {best_score}")

        plt.plot(k_values, cv_scores)
        plt.xlabel("Value of n_estimators for Random Forest Classifier")
        plt.ylabel("Testing Accuracy")
        plt.show()

    rf = RandomForestClassifier(n_estimators=best_k, random_state=42)
    rf.fit(X_train, y_train)

    importances = rf.feature_importances_
    feature_names = X.columns

    plt.figure(figsize=(10, 6))
    sns.barplot(x=importances, y=feature_names)
    plt.title("Random Forest Feature Importances")
    plt.xlabel("Importance")
    plt.ylabel("Feature")
    plt.tight_layout()
    plt.show()

    y_pred = rf.predict(X_test)
    y_scores = rf.predict_proba(X_test)

    return y_pred, y_scores, rf