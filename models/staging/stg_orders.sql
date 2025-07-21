{{ config(materialized='view') }}

SELECT 
    ORDER_ID,
    CUSTOMER_ID,
    STATUS,
    TO_DATE(ORDER_DATE, 'YYYY-MM-DD') AS ORDER_DATE,
    CURRENT_TIMESTAMP() AS _loaded_at
FROM {{ source('planetkart_raw', 'ORDERS') }}
