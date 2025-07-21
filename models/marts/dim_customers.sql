{{ config(materialized='table') }}

SELECT 
    {{ dbt_utils.generate_surrogate_key(['CUSTOMER_ID']) }} AS customer_key,
    CUSTOMER_ID,
    EMAIL,
    FIRST_NAME,
    LAST_NAME,
    REGION_ID,
    SIGNUP_DATE,
    CURRENT_TIMESTAMP() AS _created_at
FROM {{ ref('stg_customers') }}
