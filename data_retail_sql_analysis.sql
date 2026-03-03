use retails;
select *from data_retail;
-- 1. Products with Prices Higher Than Average in Their Category

SELECT 
    `Product ID`, 
    `Product Name`, 
    Category, 
    Price
FROM 
    data_retail AS p
WHERE 
    Price > (
        SELECT AVG(p2.Price)
        FROM data_retail AS p2
        WHERE p2.Category = p.Category
    )

-- 2. Categories with Highest Average Rating Across Products
SELECT 
Category,
    AVG(Rating) AS avg_rating
FROM 
    data_retail
GROUP BY 
    Category
ORDER BY 
    avg_rating DESC;

-- 3. Most Reviewed Products in Each Warehouse
SELECT Warehouse, `Product Name`, Reviews
FROM (
    SELECT 
        Warehouse, `Product Name`, Reviews,
		rank() OVER (PARTITION BY Warehouse ORDER BY Reviews DESC) AS rk
    FROM data_retail
) ranked
WHERE rk = 1;

-- 4. Products Priced Above Category Average with Discount and Supplier Info
SELECT 
    `Product ID`, 
    `Product Name`, 
    Category, 
    Price, 
    Discount, 
    Supplier
FROM 
    data_retail AS p
WHERE 
    Price > (
        SELECT AVG(p2.Price)
        FROM data_retail AS p2
        WHERE p2.Category = p.Category
    );

-- 5. Top 2 Products with Highest Rating in Each Category
SELECT * FROM (
    SELECT 
        Category, `Product ID`, `Product Name`, Rating,
        RANK() OVER (PARTITION BY Category ORDER BY Rating DESC) AS rk
    FROM data_retail
) ranked
WHERE rk <= 2;

-- 6. Return Policy Analysis (Count, Avg Stock, Total Stock, Weighted Avg Rating)
SELECT 
    `Return Policy`,
    COUNT(*) AS product_count,
    AVG(`Stock Quantity`) AS avg_stock,
    SUM(`Stock Quantity`) AS total_stock,
    ROUND(SUM(Rating * `Stock Quantity`) / NULLIF(SUM(`Stock Quantity`), 0), 2) AS weighted_avg_rating
FROM 
    data_retail
GROUP BY 
    `Return Policy`;
