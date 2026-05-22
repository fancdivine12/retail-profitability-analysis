# 📊 Retail Profitability Analysis

## Project Overview

This project analyzes retail sales and profit data to identify which product categories, sub-categories, regions, and customer segments drive business performance.

The main goal was to understand why some areas generated strong sales but weak or negative profitability.

This project uses **Excel, BigQuery SQL, and R** to clean, validate, analyze, and summarize retail profitability trends.

---

## Business Problem

The business wants to understand:

- Which product categories and sub-categories drive the most sales and profit?
- Which sub-categories contribute to profit loss?
- Which regions perform strongest and weakest?
- Which customer segments generate the most profit?
- Do high sales always lead to strong profitability?
- How might discounting relate to weaker profit margins?

---

## Tools Used

| Tool | Purpose |
|---|---|
| Excel | Initial data review, cleaning, pivot tables, and workbook analysis |
| BigQuery SQL | Data validation, profitability analysis, margin calculations, and business queries |
| R | Reproducible analysis, validation of SQL findings, exported summary tables, and visuals |
| GitHub | Project documentation, code storage, and portfolio organization |

---

## Dataset

The analysis uses a retail orders dataset containing sales, profit, discount, product, customer segment, and regional fields.

Key fields used:

- Order Date
- Ship Date
- Customer Segment
- Region
- Category
- Sub-Category
- Sales
- Profit
- Discount

The final SQL and R analysis used **10,194 order records**.

---

## Analysis Process

### 1. Data Preparation

The dataset was reviewed and prepared in Excel. The Orders sheet was used as the primary row-level dataset for SQL and R analysis.

### 2. Data Validation

SQL and R were used to check the dataset before analysis.

Validation results:

| Check | Result |
|---|---:|
| Total rows | 10,194 |
| Missing region values | 0 |
| Missing category values | 0 |
| Missing sub-category values | 0 |
| Missing segment values | 0 |
| Missing sales values | 0 |
| Missing profit values | 0 |
| Duplicate rows in R | 0 |

### 3. SQL Analysis

BigQuery SQL was used to:

- Create a clean view with standardized column names
- Validate row counts and missing values
- Calculate total sales, total profit, and profit margin
- Compare profitability by category
- Identify loss-driving sub-categories
- Compare region and segment performance
- Analyze discount impact by sub-category
- Identify high-sales but weak-profit areas

### 4. R Analysis

R was used to reproduce and validate the SQL findings. The R script also exported summary tables and created visuals for portfolio documentation.

R analysis included:

- Data quality summary
- Overall business performance
- Profit by category
- Profit by sub-category
- Loss-driving sub-categories
- Profit by region
- Profit by customer segment
- Discount impact by sub-category
- High-sales but weak-profit analysis

---

## Key Results

### Overall Business Performance

| Metric | Value |
|---|---:|
| Total Sales | $2,326,534.35 |
| Total Profit | $292,296.81 |
| Overall Profit Margin | 12.56% |

---

### Loss-Driving Sub-Categories

| Sub-Category | Total Sales | Total Profit | Profit Margin |
|---|---:|---:|---:|
| Tables | $208,020.18 | -$17,753.21 | -8.53% |
| Bookcases | $115,361.20 | -$3,632.07 | -3.15% |
| Supplies | $46,725.50 | -$1,171.39 | -2.51% |

Tables were the largest profit-loss driver despite generating high sales.

---

### Regional Profitability

| Region | Total Sales | Total Profit | Profit Margin |
|---|---:|---:|---:|
| West | $739,813.61 | $110,798.82 | 14.98% |
| East | $691,828.17 | $94,883.26 | 13.71% |
| South | $391,721.91 | $46,749.43 | 11.93% |
| Central | $503,170.67 | $39,865.31 | 7.92% |

The West region generated the highest total profit, while the Central region had the weakest profit margin.

---

### Customer Segment Profitability

| Segment | Total Sales | Total Profit | Profit Margin |
|---|---:|---:|---:|
| Consumer | $1,170,659.79 | $136,371.45 | 11.65% |
| Corporate | $715,806.13 | $94,249.64 | 13.17% |
| Home Office | $440,068.43 | $61,675.73 | 14.02% |

Consumer customers generated the most total profit, while Home Office had the strongest profit margin.

---

## Key Insights

1. High sales did not always lead to strong profitability.
2. Tables, Bookcases, and Supplies had negative total profit.
3. Tables generated over $208K in sales but lost over $17K in profit.
4. The Central region had the weakest profit margin compared with other regions.
5. Consumer customers generated the most total profit, but Home Office had the strongest margin.
6. Discount patterns may be related to weaker profitability, especially in low-margin sub-categories.

---

## Business Recommendations

Based on the analysis, the business should:

1. Review pricing and discount strategies for Tables, Bookcases, and Supplies.
2. Investigate cost factors such as shipping, supplier costs, and fulfillment costs for loss-driving products.
3. Evaluate whether high-sales, low-profit products should be repriced, bundled, or promoted differently.
4. Study why the Central region has a weaker profit margin.
5. Use both sales and profit margin when evaluating product performance.

---

## Limitations

This analysis identifies patterns, not confirmed causes. The dataset does not include all possible cost factors, such as:

- Shipping cost
- Supplier cost
- Marketing spend
- Product return cost
- Promotion history
- Inventory holding cost

Because of this, the analysis can show which areas underperform, but it cannot prove the exact reason why they underperform.

---

## Conclusion

This project demonstrates how Excel, SQL, and R can be used together to analyze business performance.

The analysis found that sales volume alone is not enough to evaluate success. Several sub-categories generated strong sales but weak or negative profit, showing the importance of reviewing profit margin alongside revenue.

The findings support business decisions around pricing, discount strategy, product focus, and regional performance review.
