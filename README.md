\# Olist E-commerce: SQL + Power BI Analysis



!\[Dashboard](olist\_dashboard.png)



Analysis of the public Brazilian Olist marketplace dataset (Kaggle: "Brazilian E-Commerce Public Dataset by Olist") using MySQL and Power BI.



\## Business questions

1\. Is the marketplace growing?

2\. How many customers are repeat buyers?

3\. Do late deliveries lead to lower reviews?

4\. Which states earn the most revenue?

5\. How does revenue change month to month?



\## Key findings

\- Monthly orders grew from 789 (Jan 2017) to 7,220 (Jan 2018), about 9x, peaked at 7,451 in Nov 2017, then flattened at roughly 6,200 to 7,200 a month.

\- Only 3.12% of customers (2,997 of 96,096) placed a repeat order.

\- Late deliveries (about 8% of delivered orders) averaged 2.57 review stars vs 4.29 for on-time orders.

\- The state SP generated about 38% of revenue, and the top 3 states (SP, RJ, MG) about 63%.



\## SQL skills used

JOINs, GROUP BY, HAVING, CASE WHEN, CTEs, window functions (RANK, LAG), date functions.



\## Notes

\- Revenue = item price only (freight excluded).

\- The months 2016-09, 2016-12 and 2018-09 have very few orders and 2016-11 is missing, so they are left out of trend claims.

\- Some orders have more than one review, so reviews were averaged per order before joining.

\- Late orders score lower, but this analysis does not prove lateness alone causes bad reviews.



\## How to run

Download the dataset from Kaggle, load it into MySQL, then run `olist\_analysis.sql`.



\## Files

\- `olist\_analysis.sql`: all 5 queries

\- `olist\_dashboard.png`: dashboard screenshot

