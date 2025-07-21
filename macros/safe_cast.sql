{% macro safe_cast(column_name, type) %}
    TRY_CAST({{ column_name }} AS {{ type }})
{% endmacro %}
