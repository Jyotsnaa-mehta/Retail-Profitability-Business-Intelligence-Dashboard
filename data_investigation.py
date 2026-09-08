import pandas as pd

file_path = r"C:\Users\bohar\Desktop\Retail-Profitability-BI-Platform\Dataset\superstore.csv"

df = pd.read_csv(file_path)

print("Dataset loaded successfully!")

print("Dataset shape:")
print(df.shape)

print("\nColumn names:")
print(df.columns)

print("\nFirst 5 rows:")
print(df.head())

print("\nData types:")
print(df.dtypes)

print("\nMissing values:")
print(df.isnull().sum())

print("\nRows with missing Order Date:")
print(df[df["Order Date"].isnull()].head())

print("\nNumber of malformed records:")
print(df["Order Date"].isnull().sum())

valid_df = df[df["Order Date"].notnull()]

print("\nValid transaction records:")
print(len(valid_df))

print("\nMissing postal codes in valid transactions:")
print(valid_df["Postal Code"].isnull().sum())

print("\nDuplicate records in valid transactions:")
print(valid_df.duplicated().sum())

print("\nUnique Order IDs:")
print(valid_df["Order ID"].nunique())

print("\nTotal valid transaction rows:")
print(len(valid_df))

print("\nStatistical summary:")
print(valid_df.describe())

print("\nAverage profit by discount level:")

discount_analysis = valid_df.groupby("Discount")["Profit"].mean()

print(discount_analysis)

print("\nProfitability by category:")

category_analysis = valid_df.groupby("Category").agg(
    Total_Sales=("Sales", "sum"),
    Total_Profit=("Profit", "sum"),
    Average_Discount=("Discount", "mean")
)

print(category_analysis)

print("\nProfitability by sub-category:")

subcategory_analysis = valid_df.groupby("Sub-Category").agg(
    Total_Sales=("Sales", "sum"),
    Total_Profit=("Profit", "sum"),
    Average_Discount=("Discount", "mean")
).sort_values("Total_Profit")

print(subcategory_analysis)

subcategory_analysis["Profit_Margin"] = (
    subcategory_analysis["Total_Profit"]
    / subcategory_analysis["Total_Sales"]
) * 100

print("\nSub-category profitability with margins:")
print(subcategory_analysis.round(2))

print("\nBottom 10 products by profit:")

product_analysis = valid_df.groupby("Product Name").agg(
    Total_Sales=("Sales", "sum"),
    Total_Profit=("Profit", "sum"),
    Average_Discount=("Discount", "mean")
).sort_values("Total_Profit")

print(product_analysis.head(10).round(2))

cleaned_file_path = r"C:\Users\bohar\Desktop\Retail-Profitability-BI-Platform\Dataset\superstore_cleaned.csv"

valid_df.to_csv(cleaned_file_path, index=False)

print("\nCleaned dataset saved successfully!")