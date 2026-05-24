import pandas as pd


df = pd.read_csv("walmart_sales.csv")

print(df.head())
print(df.info())
print(df.isnull().sum())
print("Duplicados:", df.duplicated().sum())

df = df.drop_duplicates()
df = df.dropna()

df.columns = (
    df.columns.str.strip()
    .str.lower()
    .str.replace(" ", "_", regex=False)
    .str.replace("%", "pct", regex=False)
)

df["date"] = pd.to_datetime(df["date"], dayfirst=True)
df["year"] = df["date"].dt.year
df["month"] = df["date"].dt.month
df["day"] = df["date"].dt.day

df.to_csv("walmart_sales_clean.csv", index=False)
print("Dataset limpio guardado como walmart_sales_clean.csv")
