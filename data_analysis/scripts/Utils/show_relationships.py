import matplotlib.pyplot as plt
import seaborn as sns


def show_relationship_between_speed_and_quadrant(stroke_event_df):
    print("DataFrame with Magnitude_Speed:")
    print(stroke_event_df.head())

    mean_speeds_components = stroke_event_df.groupby("Start_Quadrant")[
        ["Speed_X", "Speed_Y", "Magnitude_Speed"]].mean().reset_index()
    print("\nMean Speeds (X, Y, and Magnitude) by Start Quadrant:")
    print(mean_speeds_components)

    sns.set_theme(style="whitegrid")

    # Box Plots
    fig, axes = plt.subplots(nrows=1, ncols=3, figsize=(18, 5))

    sns.boxplot(x="Start_Quadrant", y='Speed_X', data=stroke_event_df, ax=axes[0])
    axes[0].set_title("Speed_X Distribution by Start Quadrant")
    axes[0].set_xlabel("Start Quadrant")
    axes[0].set_ylabel("Speed_X")

    sns.boxplot(x='Start_Quadrant', y='Speed_Y', data=stroke_event_df, ax=axes[1])
    axes[1].set_title('Speed_Y Distribution by Start Quadrant')
    axes[1].set_xlabel('Start Quadrant')
    axes[1].set_ylabel('Speed_Y')

    sns.boxplot(x='Start_Quadrant', y='Magnitude_Speed', data=stroke_event_df, ax=axes[2])
    axes[2].set_title('Magnitude Speed Distribution by Start Quadrant')
    axes[2].set_xlabel('Start Quadrant')
    axes[2].set_ylabel('Magnitude Speed')

    plt.tight_layout()
    plt.show()

    # Violin Plots
    fig, axes = plt.subplots(1, 3, figsize=(18, 5))

    sns.violinplot(x='Start_Quadrant', y='Speed_X', data=stroke_event_df, ax=axes[0])
    axes[0].set_title('Speed_X Distribution by Start Quadrant')
    axes[0].set_xlabel('Start Quadrant')
    axes[0].set_ylabel('Speed_X')

    sns.violinplot(x='Start_Quadrant', y='Speed_Y', data=stroke_event_df, ax=axes[1])
    axes[1].set_title('Speed_Y Distribution by Start Quadrant')
    axes[1].set_xlabel('Start Quadrant')
    axes[1].set_ylabel('Speed_Y')

    sns.violinplot(x='Start_Quadrant', y='Magnitude_Speed', data=stroke_event_df, ax=axes[2])
    axes[2].set_title('Magnitude Speed Distribution by Start Quadrant')
    axes[2].set_xlabel('Start Quadrant')
    axes[2].set_ylabel('Magnitude Speed')

    plt.tight_layout()
    plt.show()


def show_random_forest_feature_importances(importances, feature_names):
    plt.figure(figsize=(10, 6))
    sns.barplot(x=importances, y=feature_names)
    plt.title("Random Forest Feature Importances")
    plt.xlabel("Importance")
    plt.ylabel("Feature")
    plt.tight_layout()
    plt.show()


def show_random_forest_accuracies_based_on_tested_n_estimators(n_estimators_values, cv_scores):
    plt.plot(n_estimators_values, cv_scores)
    plt.xlabel("Value of n_estimators for Random Forest Classifier")
    plt.ylabel("Testing Accuracy")
    plt.show()