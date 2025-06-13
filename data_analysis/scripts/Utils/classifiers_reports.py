import numpy as np

from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import cross_val_score

from scripts.algorithms.equal_error_rate import compute_multiclass_eer
from scripts.algorithms.false_acceptance_rate import calculate_overall_far
from scripts.algorithms.false_rejection_rate import calculate_overall_frr


def print_classifier_performance(classifier_name, classifier, X_scaled, y, y_test, y_pred, y_scores):
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
    print(f"{classifier_name} 5-fold CV mean accuracy:", np.round(cv.mean(), decimals=4))
