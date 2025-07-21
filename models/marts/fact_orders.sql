{{ config(materialized='table') }}

WITH order_aggregations AS (
    SELECT 
        o.ORDER_ID,
        o.CUSTOMER_ID,
        o.STATUS,
        o.ORDER_DATE,
        COUNT(oi.PRODUCT_ID) AS total_items,
        SUM(oi.QUANTITY) AS total_quantity,
        SUM(oi.LINE_TOTAL) AS order_total
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_order_items') }} oi 
        ON o.ORDER_ID = oi.ORDER_ID
    GROUP BY o.ORDER_ID, o.CUSTOMER_ID, o.STATUS, o.ORDER_DATE
)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['ORDER_ID']) }} AS order_key,
    oa.ORDER_ID,
    dc.customer_key,
    dr.region_key,
    oa.STATUS,
    oa.ORDER_DATE,
    oa.total_items,
    oa.total_quantity,
    oa.order_total,
    CURRENT_TIMESTAMP() AS _created_at
FROM order_aggregations oa
LEFT JOIN {{ ref('dim_customers') }} dc 
    ON oa.CUSTOMER_ID = dc.CUSTOMER_ID
LEFT JOIN {{ ref('stg_customers') }} sc 
    ON oa.CUSTOMER_ID = sc.CUSTOMER_ID
LEFT JOIN {{ ref('dim_regions') }} dr 
    ON sc.REGION_ID = dr.REGION_ID
