-- TASK 1
SELECT
    p.prod_subcategory,
    EXTRACT(year FROM s.time_id) AS sales_year,
    SUM(s.amount_sold) AS total_sales
FROM
    sh.sales s
JOIN
    sh.products p ON s.prod_id = p.prod_id
WHERE
    EXTRACT(year FROM s.time_id) BETWEEN 1998 AND 2001
GROUP BY
    p.prod_subcategory,
    EXTRACT(year FROM s.time_id)
ORDER BY
    p.prod_subcategory,
    sales_year;
	
	
-- TASK 2
	
WITH subcategory_sales AS (
    SELECT
        p.prod_subcategory,
        EXTRACT(year FROM s.time_id) AS sales_year,
        SUM(s.amount_sold) AS total_sales
    FROM
        sh.sales s
    JOIN
        sh.products p ON s.prod_id = p.prod_id
    WHERE
        EXTRACT(year FROM s.time_id) BETWEEN 1998 AND 2001
    GROUP BY
        p.prod_subcategory,
        EXTRACT(year FROM s.time_id)
)
SELECT
    *,
    LAG(total_sales) OVER (PARTITION BY prod_subcategory ORDER BY sales_year) AS prev_year_sales
FROM
    subcategory_sales
ORDER BY
    prod_subcategory,
    sales_year;

-- TASK 3

WITH subcategory_sales AS (
    SELECT
        p.prod_subcategory,
        EXTRACT(year FROM s.time_id) AS sales_year,
        SUM(s.amount_sold) AS total_sales
    FROM
        sh.sales s
    JOIN
        sh.products p ON s.prod_id = p.prod_id
    WHERE
        EXTRACT(year FROM s.time_id) BETWEEN 1998 AND 2001
    GROUP BY
        p.prod_subcategory,
        EXTRACT(year FROM s.time_id)
),
prev_year_sales AS (
    SELECT
        *,
        LAG(total_sales) OVER (PARTITION BY prod_subcategory ORDER BY sales_year) AS prev_year_sales
    FROM
        subcategory_sales
)
SELECT DISTINCT
    prod_subcategory
FROM
    prev_year_sales
WHERE
    total_sales > prev_year_sales;
	
	
-- TASK 4
	
WITH subcategory_sales AS (
    SELECT
        p.prod_subcategory,
        EXTRACT(year FROM s.time_id) AS sales_year,
        SUM(s.amount_sold) AS total_sales
    FROM
        sh.sales s
    JOIN
        sh.products p ON s.prod_id = p.prod_id
    WHERE
        EXTRACT(year FROM s.time_id) BETWEEN 1998 AND 2001
    GROUP BY
        p.prod_subcategory,
        EXTRACT(year FROM s.time_id)
),
prev_year_sales AS (
    SELECT
        *,
        LAG(total_sales) OVER (PARTITION BY prod_subcategory ORDER BY sales_year) AS prev_year_sales
    FROM
        subcategory_sales
),
higher_sales AS (
    SELECT DISTINCT
        prod_subcategory
    FROM
        prev_year_sales
    WHERE
        total_sales > prev_year_sales
)
SELECT
    prod_subcategory
FROM
    higher_sales;

