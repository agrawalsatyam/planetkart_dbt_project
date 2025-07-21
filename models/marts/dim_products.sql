{{ config(materialized='table') }}

SELECT 
    {{ dbt_utils.generate_surrogate_key(['PRODUCT_ID']) }} AS product_key,
    PRODUCT_ID,
    PRODUCT_NAME,
    SKU,
    CATEGORY,
    COST,
    CURRENT_TIMESTAMP() AS _created_at
FROM {{ ref('stg_products') }}
