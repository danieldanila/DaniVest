from sklearn.metrics import confusion_matrix
import numpy as np


# Confusion matrix in sklearn
# +-----------+-----------+
# |           |           |
# |    TN     |    FP     |
# |           |           |
# |-----------+-----------|
# |           |           |
# |    FN     |    TP     |
# |           |           |
# +-----------+-----------+
def calculate_frr_binary_situation(y_true, y_scores, threshold):
    y_pred = (y_scores >= threshold).astype(int)

    cm = confusion_matrix(y_true, y_pred)
    print(cm)
    fn = cm[1, 0]  # False Negatives: Actual 1, Predicted 0 (False Rejection)
    tp = cm[1, 1]  # True Positives: Actual 1, Predicted 1

    total_positive_attempts = fn + tp

    if total_positive_attempts > 0:
        frr = fn / total_positive_attempts
    else:
        frr = 0.0
        print("No True Positives detected")

    return frr


def calculate_frr_single_class(y_true, y_pred, positive_class_label):
    all_labels = np.unique(np.concatenate((y_true, y_pred)))
    all_labels.sort()

    cm = confusion_matrix(y_true, y_pred, labels=all_labels)

    try:
        positive_class_index = np.where(all_labels == positive_class_label)[0][0]
    except IndexError:
        print(
            f"Error: positive_class_label '{positive_class_label}' not found in the combined set of actual or predicted labels used for the confusion matrix ({all_labels}).")
        return np.nan

    tp_k = cm[positive_class_index, positive_class_index]
    fn_k = np.sum(cm[positive_class_index, :]) - tp_k

    total_actual_genuine_attempts = fn_k + tp_k
    total_actual_genuine_attempts = max(0, total_actual_genuine_attempts)

    if total_actual_genuine_attempts > 0:
        frr = fn_k / total_actual_genuine_attempts
    else:
        frr = 0.0
        print(
            f"Note: No actual 'imposter' samples (actual classes other than '{positive_class_label}') found in the test data for FAR calculation for this class. FAR set to 0.0.")

    return frr


def calculate_overall_frr(y_true, y_pred):
    all_labels = np.unique(np.concatenate((y_true, y_pred)))
    all_labels.sort()

    individual_frrs = []
    class_supports = []

    cm_full = confusion_matrix(y_true, y_pred, labels=all_labels)

    for label in all_labels:
        frr_k = calculate_frr_single_class(y_true, y_pred, label)
        if not np.isnan(frr_k):
            individual_frrs.append(frr_k)
            class_index = np.where(all_labels == label)[0][0]
            class_supports.append(np.sum(cm_full[class_index, :]))

    if not individual_frrs:
        return np.nan

    total_support = np.sum(class_supports)
    if total_support == 0:
        print("Warning: Total support for weighted average is zero across all valid classes. Returning NaN.")
        return np.nan
    weighted_fars = [f * s for f, s in zip(individual_frrs, class_supports)]
    return np.sum(weighted_fars) / total_support
