
{% macro config_incremental() %}
    -- depends_on: {{ ref('DestinationTableProcessedPartitions') }}

    {% set base_config = {
        'materialized': 'incremental',
        'sql_where': 'TRUE',
        'post-hook': "{{ post_hook_mark_dest_dates_complete(this) }}"
    } %}

    {% set _ = base_config.update(kwargs) %}
    {{ config(base_config) }}

{% endmacro %}
