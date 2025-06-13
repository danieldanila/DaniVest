import math
import numpy as np
from sklearn.model_selection import cross_val_score
from sklearn.neighbors import KNeighborsClassifier


def k_nearest_neighbors(X_train_scaled, X_test_scaled, y_train, best_k=0):
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
        print(f"k-NN 5-fold, best k in cross validation: {best_k} with accuracy: {best_score}")

    knn = KNeighborsClassifier(n_neighbors=best_k)
    knn.fit(X_train_scaled, y_train)

    y_pred = knn.predict(X_test_scaled)
    y_scores = knn.predict_proba(X_test_scaled)

    return y_pred, y_scores, knn