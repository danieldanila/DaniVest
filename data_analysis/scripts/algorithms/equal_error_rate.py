import numpy as np
from sklearn.metrics import roc_curve
from sklearn.preprocessing import label_binarize

from scripts.algorithms.false_acceptance_rate import calculate_far_binary_situation
from scripts.algorithms.false_rejection_rate import calculate_frr_binary_situation


def calculate_eer_for_binary_situation(y_true, y_scores, num_thresholds=1000):
    min_score = np.min(y_scores)
    max_score = np.max(y_scores)

    if min_score == max_score:
        thresholds = np.array([min_score])
    else:
        thresholds = np.linspace(min_score, max_score, num_thresholds)

    far_values = []
    frr_values = []

    for threshold in thresholds:
        far = calculate_far_binary_situation(y_true, y_scores, threshold)
        frr = calculate_frr_binary_situation(y_true, y_scores, threshold)
        far_values.append(far)
        frr_values.append(frr)

    far_values = np.array(far_values)
    frr_values = np.array(frr_values)

    eer_index = np.argmin(np.abs(far_values - frr_values))

    eer = (far_values[eer_index] + frr_values[eer_index]) / 2
    eer_threshold = thresholds[eer_index]

    return eer, eer_threshold


def compute_multiclass_eer(y_true, y_scores):
    y_true = np.array(y_true)
    y_scores = np.array(y_scores)

    classes = np.unique(y_true)
    n_classes = len(classes)

    if y_scores.ndim == 1:
        if n_classes == 2:
            y_scores_binary = y_scores.reshape(-1, 1)
            y_scores = np.column_stack([1 - y_scores_binary.ravel(), y_scores_binary.ravel()])
        else:
            raise ValueError("For multiclass problems, y_scores must be 2D array with shape (n_samples, n_classes)")

    # Binarize the labels for one-vs-rest evaluation
    y_true_bin = label_binarize(y_true, classes=classes)
    if n_classes == 2:
        y_true_bin = np.column_stack([1 - y_true_bin.ravel(), y_true_bin.ravel()])

    eer_values = []
    eer_thresholds = []

    for i in range(n_classes):
        y_true_class = y_true_bin[:, i]
        y_scores_class = y_scores[:, i]

        fpr, tpr, thresholds = roc_curve(y_true_class, y_scores_class)

        eer, eer_threshold = compute_eer_from_roc(fpr, tpr, thresholds)
        eer_values.append(eer)
        eer_thresholds.append(eer_threshold)

    mean_eer = np.mean(eer_values)
    mean_eer_threshold = np.mean(eer_thresholds)

    return mean_eer, mean_eer_threshold


def compute_eer_from_roc(fpr, tpr, thresholds):
    fnr = 1 - tpr

    diff = np.abs(fpr - fnr)
    min_idx = np.argmin(diff)

    eer = (fpr[min_idx] + fnr[min_idx]) / 2.0
    eer_threshold = thresholds[min_idx] if min_idx < len(thresholds) else thresholds[-1]

    return eer, eer_threshold
