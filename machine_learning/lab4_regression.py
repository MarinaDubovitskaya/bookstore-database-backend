import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression, LassoCV, ElasticNetCV
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error
from sklearn.preprocessing import LabelEncoder

def run_analysis():
    data = {
        'Hours_Studied': np.random.randint(1, 10, 1000),
        'Previous_Scores': np.random.randint(40, 100, 1000),
        'Extracurricular': np.random.choice(['Yes', 'No'], 1000),
        'Sleep_Hours': np.random.randint(5, 10, 1000),
        'Performance_Index': np.random.randint(10, 100, 1000)
    }
    df = pd.DataFrame(data)
    le = LabelEncoder()
    df['Extracurricular'] = le.fit_transform(df['Extracurricular'])
    X = df.drop('Performance_Index', axis=1)
    y = df['Performance_Index']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    models = {
        "Linear": LinearRegression(),
        "Lasso_CV": LassoCV(alphas=np.logspace(-4, 1, 50), cv=5),
        "ElasticNet_CV": ElasticNetCV(alphas=np.logspace(-4, 1, 50), l1_ratio=[.1, .5, .9], cv=5)
    }
    for name, model in models.items():
        model.fit(X_train, y_train)
        preds = model.predict(X_test)
        print(f"--- {name} ---")
        print(f"R2: {r2_score(y_test, preds):.4f}")
        print(f"MSE: {mean_squared_error(y_test, preds):.4f}")
        print(f"MAE: {mean_absolute_error(y_test, preds):.4f}")

if __name__ == "__main__":
    run_analysis()
