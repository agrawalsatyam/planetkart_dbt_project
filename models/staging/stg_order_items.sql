{{ config(materialized='view') }}

SELECT
    ORDER_ID,
    PRODUCT_ID,
    {{ safe_cast('QUANTITY', 'INTEGER') }} AS QUANTITY,
    {{ safe_cast('UNIT_PRICE', 'DECIMAL(10,2)') }} AS UNIT_PRICE,
    {{ safe_cast('QUANTITY', 'INTEGER') }} * {{ safe_cast('UNIT_PRICE', 'DECIMAL(10,2)') }} AS LINE_TOTAL,
    CURRENT_TIMESTAMP() AS _loaded_at
FROM {{ source('planetkart_raw', 'ORDER_ITEMS') }} 
