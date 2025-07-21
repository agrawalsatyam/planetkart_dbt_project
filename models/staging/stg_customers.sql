{{ config(materialized='view') }}

SELECT 
    CUSTOMER_ID,
    EMAIL,
    FIRST_NAME,
    LAST_NAME,
    REGION_ID,
    TO_DATE(SIGNUP_DATE, 'YYYY-MM-DD') AS SIGNUP_DATE,
    CURRENT_TIMESTAMP() AS _loaded_at
FROM {{ source('planetkart_raw', 'CUSTOMERS') }}
