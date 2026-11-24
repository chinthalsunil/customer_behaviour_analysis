use customer_behaviour

SELECT * FROM dbo.customerb


--1) what is the total revenue collected by male and female customers 
select gender , sum(purchase_amount) as total_revune from dbo.customerb group by gender

--2)which customers used a discount but still spent more than avg amount 

select customer_id , purchase_amount  from dbo.customerb  where discount_applied='yes' and
purchase_amount >= (select avg(purchase_amount) from dbo.customerb)

--3. Find revenue by product category
SELECT
    category,
    COUNT(customer_id) AS Total_Customers,
    SUM(purchase_amount) AS Total_Revenue,
    AVG(purchase_amount) AS Average_Spending
FROM dbo.customerb
GROUP BY category
ORDER BY Total_Revenue DESC;

--4. Analyse seasonal sales performance
SELECT
    season,
    COUNT(customer_id) AS Total_Customers,
    SUM(purchase_amount) AS Total_Revenue,
    AVG(purchase_amount) AS Average_Spending
FROM dbo.customerb
GROUP BY season
ORDER BY Total_Revenue DESC;

--5. Identify the top 5 best-selling products
SELECT TOP 5
    item_purchased,
    COUNT(customer_id) AS Total_Purchases,
    SUM(purchase_amount) AS Total_Revenue,
    AVG(purchase_amount) AS Average_Spending
FROM dbo.customerb
GROUP BY item_purchased
ORDER BY Total_Revenue DESC;

--6. Customer spending classification
SELECT
    CASE
        WHEN purchase_amount < 40 THEN 'Low Spender'
        WHEN purchase_amount BETWEEN 40 AND 70
            THEN 'Medium Spender'
        ELSE 'High Spender'
    END AS Spending_Category,

    COUNT(customer_id) AS Total_Customers,
    SUM(purchase_amount) AS Total_Revenue,
    AVG(purchase_amount) AS Average_Spending

FROM dbo.customerb

GROUP BY
    CASE
        WHEN purchase_amount < 40 THEN 'Low Spender'
        WHEN purchase_amount BETWEEN 40 AND 70
            THEN 'Medium Spender'
        ELSE 'High Spender'
    END

ORDER BY Total_Revenue DESC;

--7. Find the top 3 products in each category
WITH ProductSales AS
(
    SELECT
        category,
        item_purchased,
        COUNT(customer_id) AS Total_Purchases,
        SUM(purchase_amount) AS Total_Revenue
    FROM dbo.customerb
    GROUP BY
        category,
        item_purchased
),
RankedProducts AS
(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY Total_Revenue DESC
        ) AS Product_Rank
    FROM ProductSales
)
SELECT
    category,
    item_purchased,
    Total_Purchases,
    Total_Revenue,
    Product_Rank
FROM RankedProducts
WHERE Product_Rank <= 3
ORDER BY category, Product_Rank;

--8. Rank product categories based on revenue
WITH CategorySales AS
(
    SELECT
        category,
        COUNT(customer_id) AS Total_Customers,
        SUM(purchase_amount) AS Total_Revenue
    FROM dbo.customerb
    GROUP BY category
)
SELECT
    category,
    Total_Customers,
    Total_Revenue,
    RANK() OVER (
        ORDER BY Total_Revenue DESC
    ) AS Revenue_Rank
FROM CategorySales;

--9. Analyse seasonal sales performance
SELECT
    season,
    COUNT(customer_id) AS Total_Customers,
    SUM(purchase_amount) AS Total_Revenue,
    AVG(purchase_amount) AS Average_Spending
FROM dbo.customerb
GROUP BY season
ORDER BY Total_Revenue DESC;

--10. Compare subscribed and non-subscribed customers
SELECT
    subscription_status,
    COUNT(customer_id) AS Total_Customers,
    SUM(purchase_amount) AS Total_Revenue,
    AVG(purchase_amount) AS Average_Spending
FROM dbo.customerb
GROUP BY subscription_status
ORDER BY Total_Revenue DESC;

--11. what is the reveune contribution of each group
select age_group , sum(purchase_amount) as spent_amount from dbo.customerb group by age_group order by spent_amount desc