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
def calculate_far_binary_situation(y_true, y_scores, threshold):
    y_pred = (y_scores >= threshold).astype(int)

    cm = confusion_matrix(y_true, y_pred)

    tn = cm[0, 0] # True Negatives: Actual 0, Predicted 0
    fp = cm[0, 1] # False Positives: Actual 0, Predicted 1 (False Acceptance)

    total_negative_attempts = fp + tn

    if total_negative_attempts > 0:
        far = fp / total_negative_attempts
    else:
        far = 0.0
        print("No True Negatives detected")

    return far


def calculate_far_single_class(y_true, y_pred, positive_class_label):
    all_labels = np.unique(np.concatenate((y_true, y_pred)))
    all_labels.sort()

    cm = confusion_matrix(y_true, y_pred, labels=all_labels)

    try:
        positive_class_index = np.where(all_labels == positive_class_label)[0][0]
    except IndexError:
        print(f"Error: positive_class_label '{positive_class_label}' not found in the combined set of actual or predicted labels used for the confusion matrix ({all_labels}).")
        return np.nan

    tp_k = cm[positive_class_index, positive_class_index]
    fp_k = np.sum(cm[:, positive_class_index]) - tp_k
    fn_k = np.sum(cm[positive_class_index, :]) - tp_k

    total_samples = np.sum(cm)
    tn_k = total_samples - tp_k - fp_k - fn_k

    total_actual_imposters = fp_k + tn_k
    total_actual_imposters = max(0, total_actual_imposters)

    if total_actual_imposters > 0:
        far = fp_k / total_actual_imposters
    else:
        far = 0.0
        print(f"Note: No actual 'imposter' samples (actual classes other than '{positive_class_label}') found in the test data for FAR calculation for this class. FAR set to 0.0.")

    return far


def calculate_overall_far(y_true, y_pred):
    all_labels = np.unique(np.concatenate((y_true, y_pred)))
    all_labels.sort()

    individual_fars = []
    class_supports = []

    cm_full = confusion_matrix(y_true, y_pred, labels=all_labels)

    for label in all_labels:
        far_k = calculate_far_single_class(y_true, y_pred, label)
        if not np.isnan(far_k):
            individual_fars.append(far_k)
            class_index = np.where(all_labels == label)[0][0]
            class_supports.append(np.sum(cm_full[class_index, :]))

    if not individual_fars:
        return np.nan

    total_support = np.sum(class_supports)
    if total_support == 0:
        print("Warning: Total support for weighted average is zero across all valid classes. Returning NaN.")
        return np.nan
    weighted_fars = [f * s for f, s in zip(individual_fars, class_supports)]
    return np.sum(weighted_fars) / total_support
