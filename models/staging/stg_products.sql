{{ config(materialized='view') }}

SELECT 
    PRODUCT_ID,
    PRODUCT_NAME,
    SKU,
    CATEGORY,
    CAST(COST AS DECIMAL(10,2)) AS COST,
    CURRENT_TIMESTAMP() AS _loaded_at
FROM {{ source('planetkart_raw', 'PRODUCTS') }}
