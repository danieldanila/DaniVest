import numpy as np
from scipy.interpolate import interp1d
from scipy.optimize import brentq
from sklearn.metrics import roc_curve

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


def calculate_eer_single_class(y_true, y_scores, positive_class_label, model_classes):
    if y_true.shape[0] != y_scores.shape[0]:
        raise ValueError("y_true and y_scores must have the same number of samples.")

    try:
        positive_class_col_index = np.where(model_classes == positive_class_label)[0][0]
        if not (0 <= positive_class_col_index < y_scores.shape[1]):
            raise IndexError(
                f"Mapped index {positive_class_col_index} is out of bounds for y_scores columns (0 to {y_scores.shape[1] - 1}).")
    except IndexError as e:
        print(
            f"Error: positive_class_label '{positive_class_label}' not found in model_classes or index out of bounds: {e}. Cannot calculate EER.")
        return np.nan
    except Exception as e:
        print(
            f"An unexpected error occurred during class index mapping for '{positive_class_label}': {e}. Cannot calculate EER.")
        return np.nan

    y_true_binary = (y_true == positive_class_label).astype(int)
    scores_for_positive_class = y_scores[:, positive_class_col_index]

    if np.sum(y_true_binary == 1) == 0:
        print(
            f"Warning: No true positive samples (actual '{positive_class_label}') for EER calculation for this class. Returning NaN.")
        return np.nan
    if np.sum(y_true_binary == 0) == 0:
        print(f"Warning: No true negative samples (imposters) for EER calculation for this class. Returning NaN.")
        return np.nan

    fpr, tpr, thresholds = roc_curve(y_true_binary, scores_for_positive_class, pos_label=1)
    frr = 1 - tpr

    try:
        unique_thresholds, unique_indices = np.unique(thresholds, return_index=True)
        interp_fpr = interp1d(unique_thresholds, fpr[unique_indices], kind="linear", bounds_error=False,
                              fill_value=(0.0, 1.0))
        interp_frr = interp1d(unique_thresholds, frr[unique_indices], kind="linear", bounds_error=False,
                              fill_value=(0.0, 1.0))

        func = lambda x: interp_fpr(x) - interp_frr(x)

        eer_threshold = None
        for i in range(len(thresholds) - 1):
            if func(thresholds[i]) * func(thresholds[i + 1]) < 0:
                try:
                    eer_threshold = brentq(func, thresholds[i + 1], thresholds[i])
                    break
                except ValueError:
                    continue

        if eer_threshold is not None:
            eer_value = interp_fpr(eer_threshold)
        else:
            idx = np.nanargmin(np.abs(fpr - frr))
            eer_value = (fpr[idx] + frr[idx]) / 2.0

    except Exception as e:
        abs_diffs = np.abs(fpr - frr)
        eer_idx = np.nanargmin(abs_diffs)
        eer_value = (fpr[eer_idx] + frr[eer_idx]) / 2.0

    return eer_value


def calculate_overall_eer(y_true, y_scores, model_classes):
    all_labels = model_classes

    individual_eers = []
    class_supports = []

    for label in all_labels:
        eer_k = calculate_eer_single_class(y_true, y_scores, label, model_classes)

        if not np.isnan(eer_k):
            individual_eers.append(eer_k)
            class_supports.append(np.sum(y_true == label))

    if not individual_eers:
        print("Note: No valid individual EERs could be calculated for any class. Returning NaN.")
        return np.nan

    total_support = np.sum(class_supports)
    if total_support == 0:
        print(
            "Warning: Total support for weighted average EER is zero across all valid EER classes. Returning NaN.")
        return np.nan
    weighted_eers = [e * s for e, s in zip(individual_eers, class_supports)]
    return np.sum(weighted_eers) / total_support
