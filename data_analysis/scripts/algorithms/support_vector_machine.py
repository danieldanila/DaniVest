import joblib

from sklearn.model_selection import GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC


def support_vector_machine(X, y, X_train_scaled, X_test_scaled, y_train, param_grid, feature_name, best_c=0,
                           best_gamma=0, best_kernel="rbf"):
    if best_c == 0 and best_gamma == 0:
        svm = SVC()
        scaler = StandardScaler()

        pipeline = Pipeline([
            ("scaler", scaler),
            ("svm", svm)
        ])

        grid = GridSearchCV(pipeline, param_grid, cv=5, scoring="accuracy", n_jobs=-1)

        grid.fit(X, y)

        best_c = grid.best_params_['svm__C']
        best_gamma = grid.best_params_['svm__gamma']
        best_kernel = grid.best_params_['svm__kernel']

        print("SVM, best parameters:", grid.best_params_)
        print("SVM, best cross-val accuracy:", grid.best_score_)

    svm = SVC(kernel=best_kernel, C=best_c, gamma=best_gamma)
    svm.fit(X_train_scaled, y_train)

    joblib.dump(svm, f"..\\data\\models\\{feature_name}_svm_model.pkl")

    y_pred = svm.predict(X_test_scaled)
    y_scores = svm.decision_function(X_test_scaled)

    return y_pred, y_scores, svm
