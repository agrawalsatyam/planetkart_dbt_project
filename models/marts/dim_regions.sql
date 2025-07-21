{{ config(materialized='table') }}

SELECT 
    {{ dbt_utils.generate_surrogate_key(['REGION_ID']) }} AS region_key,
    REGION_ID,
    ZONE,
    PLANET,
    CURRENT_TIMESTAMP() AS _created_at
FROM {{ ref('stg_regions') }}
