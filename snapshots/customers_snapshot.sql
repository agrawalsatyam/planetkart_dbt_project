{% snapshot customers_snapshot %}
    {{
        config(
          target_schema='planetkart_analytics',
          unique_key='CUSTOMER_ID',
          strategy='timestamp',
          updated_at='_loaded_at',
        )
    }}
    
    SELECT * FROM {{ ref('stg_customers') }}
    
{% endsnapshot %}
