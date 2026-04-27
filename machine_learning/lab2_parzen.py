import numpy as np
import pandas as pd
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, classification_report

class ParzenWindowClassifier:
    def __init__(self, k=5):
        self.k = k
        self.X_train = None
        self.y_train = None
        self.scaler = StandardScaler()

    def epanechnikov_kernel(self, r):
        return 0.75 * (1 - r**2) if abs(r) <= 1 else 0

    def fit(self, X, y):
        self.X_train = self.scaler.fit_transform(X)
        self.y_train = np.array(y)
        self.classes = np.unique(y)

    def predict(self, X):
        X_scaled = self.scaler.transform(X)
        return np.array([self._predict_one(x) for x in X_scaled])

    def _predict_one(self, x):
        distances = np.sqrt(np.sum((self.X_train - x)**2, axis=1))
        # Находим расстояние до k-го соседа для адаптивного окна
        k_dist = sorted(distances)[self.k]
        
        if k_dist == 0: k_dist = 1e-10
        
        weights = np.array([self.epanechnikov_kernel(d / k_dist) for d in distances])
        
        class_scores = {cls: np.sum(weights[self.y_train == cls]) for cls in self.classes}
        return max(class_scores, key=class_scores.get)

if __name__ == "__main__":
    iris = load_iris()
    X_train, X_test, y_train, y_test = train_test_split(iris.data, iris.target, test_size=0.3, random_state=42)
    
    model = ParzenWindowClassifier(k=7)
    model.fit(X_train, y_train)
    preds = model.predict(X_test)
    
    print(f"Accuracy: {accuracy_score(y_test, preds):.4f}")
    print("\nClassification Report:\n", classification_report(y_test, preds))
