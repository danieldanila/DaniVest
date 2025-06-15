import numpy as np
import joblib

from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score

from scripts.Utils.show_relationships import show_random_forest_feature_importances, \
    show_random_forest_accuracies_based_on_tested_n_estimators


def random_forest_classifier(X, X_train, X_test, y_train, feature_name, best_n_estimators=0, show_plots=False):
    if best_n_estimators == 0:
        n_estimators_values = list(range(1, 202, 50))
        cv_scores = []

        for n_estimator in n_estimators_values:
            rfc = RandomForestClassifier(n_estimators=n_estimator)
            scores = cross_val_score(rfc, X_train, y_train, cv=5, scoring="accuracy")
            cv_scores.append(scores.mean())

        best_index = np.argmax(cv_scores)
        best_n_estimators = n_estimators_values[best_index]
        best_score = cv_scores[best_index]
        print(
            f"Random Forest 5-fold, best n_estimator in cross validation: {best_n_estimators} with accuracy: {best_score}")

        if show_plots:
            show_random_forest_accuracies_based_on_tested_n_estimators(n_estimators_values=n_estimators_values,
                                                                       cv_scores=cv_scores)

    rf = RandomForestClassifier(n_estimators=best_n_estimators, random_state=42)
    rf.fit(X_train, y_train)

    joblib.dump(rf, f"..\\data\\models\\{feature_name}_rf_model.pkl")

    y_pred = rf.predict(X_test)
    y_scores = rf.predict_proba(X_test)

    if show_plots:
        show_random_forest_feature_importances(importances=rf.feature_importances_, feature_names=X.columns)

    return y_pred, y_scores, rf
