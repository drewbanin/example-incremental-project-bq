

{% macro generate_schema_name(schema_name) -%}
    {{ return(model.fqn[1] | trim) }}
{%- endmacro %}
