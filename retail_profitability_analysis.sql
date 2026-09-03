USE retail_profitability;

SELECT COUNT(*) AS total_rows
FROM superstore;

SELECT
  ROUND(SUM(Sales), 2) AS total_revenue,
  ROUND(SUM(Profit), 2) AS total_profit,
  ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct,
  COUNT(*) AS total_transactions,
  COUNT(DISTINCT `Order ID`) AS total_orders,
  COUNT(DISTINCT `Customer ID`) AS total_customers,
  ROUND(100 * AVG(Discount), 2) AS avg_discount_pct,
  SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS loss_transactions,
  ROUND(100 * SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loss_txn_pct
FROM superstore;

SELECT
  Category,
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Profit), 2) AS total_profit,
  ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct,
  ROUND(100 * AVG(Discount), 2) AS avg_discount_pct
FROM superstore
GROUP BY Category
ORDER BY total_profit DESC;

SELECT
  Category,
  `Sub-Category`,
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Profit), 2) AS total_profit,
  ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct,
  ROUND(100 * AVG(Discount), 2) AS avg_discount_pct
FROM superstore
GROUP BY Category, `Sub-Category`
ORDER BY total_profit ASC;

SELECT
  `Sub-Category`,
  COUNT(*) AS transactions,
  SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS loss_transactions,
  ROUND(100 * SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loss_txn_pct,
  ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
WHERE Category = 'Furniture'
GROUP BY `Sub-Category`
ORDER BY total_profit ASC;

SELECT
  `Sub-Category`,
  discount_band,
  COUNT(*) AS transactions,
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Profit), 2) AS total_profit,
  ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales),0), 2) AS profit_margin_pct,
  ROUND(100 * SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loss_txn_pct
FROM (
  SELECT
    `Sub-Category`,
    Sales,
    Profit,
    CASE
      WHEN Discount = 0 THEN '0%'
      WHEN Discount > 0 AND Discount <= 0.10 THEN '0–10%'
      WHEN Discount > 0.10 AND Discount <= 0.20 THEN '10–20%'
      WHEN Discount > 0.20 AND Discount <= 0.30 THEN '20–30%'
      WHEN Discount > 0.30 AND Discount <= 0.40 THEN '30–40%'
      WHEN Discount > 0.40 AND Discount <= 0.50 THEN '40–50%'
      ELSE '50%+'
    END AS discount_band
  FROM superstore
  WHERE Category='Furniture'
    AND `Sub-Category` IN ('Tables','Bookcases')
) x
GROUP BY `Sub-Category`, discount_band
ORDER BY `Sub-Category`,
  CASE discount_band
    WHEN '0%' THEN 1
    WHEN '0–10%' THEN 2
    WHEN '10–20%' THEN 3
    WHEN '20–30%' THEN 4
    WHEN '30–40%' THEN 5
    WHEN '40–50%' THEN 6
    ELSE 7
  END;

SELECT
  Region,
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Profit), 2) AS total_profit,
  ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct,
  ROUND(100 * AVG(Discount), 2) AS avg_discount_pct
FROM superstore
GROUP BY Region
ORDER BY total_profit ASC;

SELECT
  Region,
  `Sub-Category`,
  COUNT(*) AS transactions,
  ROUND(100 * AVG(Discount), 2) AS avg_discount_pct,
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Profit), 2) AS total_profit,
  ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct,
  ROUND(100 * SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loss_txn_pct
FROM superstore
WHERE Category='Furniture'
  AND `Sub-Category` IN ('Tables','Bookcases')
GROUP BY Region, `Sub-Category`
ORDER BY total_profit ASC;

SELECT
  COUNT(*) AS total_txn,
  SUM(CASE WHEN Discount >= 0.30 THEN 1 ELSE 0 END) AS txn_discount_30_plus,
  ROUND(100 * SUM(CASE WHEN Discount >= 0.30 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_discount_30_plus,
  ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
WHERE Region='East'
  AND Category='Furniture'
  AND `Sub-Category`='Tables';

SELECT
  `Product Name`,
  COUNT(*) AS transactions,
  ROUND(100 * AVG(Discount), 2) AS avg_discount_pct,
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Profit), 2) AS total_profit,
  ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct
FROM superstore
WHERE Region='East'
  AND Category='Furniture'
  AND `Sub-Category`='Tables'
GROUP BY `Product Name`
ORDER BY total_profit ASC
LIMIT 10;

SELECT
  discount_band,
  COUNT(*) AS transactions,
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Profit), 2) AS total_profit,
  ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct,
  ROUND(100 * SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loss_txn_pct
FROM (
  SELECT
    Sales, Profit, Discount,
    CASE
      WHEN Discount = 0 THEN '0%'
      WHEN Discount > 0 AND Discount <= 0.20 THEN '0–20%'
      WHEN Discount > 0.20 AND Discount < 0.30 THEN '20–30%'
      ELSE '30%+'
    END AS discount_band
  FROM superstore
  WHERE Region='Central'
    AND Category='Furniture'
    AND `Sub-Category`='Bookcases'
) t
GROUP BY discount_band
ORDER BY
  CASE discount_band
    WHEN '0%' THEN 1
    WHEN '0–20%' THEN 2
    WHEN '20–30%' THEN 3
    ELSE 4
  END;

SELECT
  `Product Name`,
  COUNT(*) AS transactions,
  ROUND(100 * AVG(Discount), 2) AS avg_discount_pct,
  ROUND(SUM(Sales), 2) AS total_sales,
  ROUND(SUM(Profit), 2) AS total_profit,
  ROUND(100 * SUM(Profit) / NULLIF(SUM(Sales), 0), 2) AS profit_margin_pct
FROM superstore
WHERE Region='Central'
  AND Category='Furniture'
  AND `Sub-Category`='Bookcases'
  AND Discount >= 0.30
GROUP BY `Product Name`
ORDER BY total_profit ASC
LIMIT 10;