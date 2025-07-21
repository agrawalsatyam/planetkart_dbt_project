{{ config(materialized='view') }}

SELECT 
    REGION_ID,
    ZONE,
    PLANET,
    CURRENT_TIMESTAMP() AS _loaded_at
FROM {{ source('planetkart_raw', 'REGIONS') }}
