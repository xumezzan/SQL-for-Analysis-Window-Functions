WITH ranked_customers AS (
    SELECT
        cust_id,
        RANK() OVER (ORDER BY SUM(amount_sold) DESC) AS sales_rank
    FROM
        sh.sales
    WHERE
        EXTRACT(year FROM time_id) IN (1998, 1999, 2001)
    GROUP BY
        cust_id
),
sales_by_channel AS (
    SELECT
        s.cust_id,
        c.channel_id,
        SUM(s.amount_sold) AS total_sales
    FROM
        sh.sales s
    JOIN
        sh.channels c ON s.channel_id = c.channel_id
    WHERE
        EXTRACT(year FROM s.time_id) IN (1998, 1999, 2001)
    GROUP BY
        s.cust_id,
        c.channel_id
)
SELECT
    rc.sales_rank,
    c.channel_id,
    ROUND(sb.total_sales, 2) AS total_sales
FROM
    ranked_customers rc
JOIN
    sales_by_channel sb ON rc.cust_id = sb.cust_id
JOIN
    sh.channels c ON sb.channel_id = c.channel_id
WHERE
    rc.sales_rank <= 300
ORDER BY
    rc.sales_rank,
    c.channel_id;
