import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report

def prepare_data(df):
    df['Age'] = df['Age'].fillna(df['Age'].median())
    df['Embarked'] = df['Embarked'].fillna(df['Embarked'].mode()[0])
    if 'Cabin' in df.columns: df = df.drop(['Cabin'], axis=1)
    if 'Name' in df.columns: df = df.drop(['Name'], axis=1)
    if 'Ticket' in df.columns: df = df.drop(['Ticket'], axis=1)
    if 'PassengerId' in df.columns: df = df.drop(['PassengerId'], axis=1)
    df['Sex'] = df['Sex'].map({'female': 0, 'male': 1})
    df = pd.get_dummies(df, columns=['Embarked'], drop_first=True)
    return df

if __name__ == "__main__":
    import seaborn as sns
    df = sns.load_dataset('titanic')
    df = df.rename(columns={'survived': 'Survived', 'pclass': 'Pclass', 'sex': 'Sex', 'age': 'Age', 'sibsp': 'SibSp', 'parch': 'Parch', 'fare': 'Fare', 'embarked': 'Embarked'})
    df_clean = prepare_data(df)
    X = df_clean.drop('Survived', axis=1)
    y = df_clean['Survived']
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    clf = DecisionTreeClassifier(criterion='gini', max_depth=10, min_samples_leaf=5, random_state=42)
    clf.fit(X_train, y_train)
    preds = clf.predict(X_test)
    print(f"Accuracy: {accuracy_score(y_test, preds):.4f}")
    print(confusion_matrix(y_test, preds))
    print(classification_report(y_test, preds))
