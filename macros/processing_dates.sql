

{% macro post_hook_mark_dest_dates_complete(tableName, completed_dates) %}
  {% if not completed_dates %}
    {{ return([]) }}
  {% endif %}

  -- depends_on: ref('DestinationTableProcessedPartitions')
  INSERT INTO {{ ref("DestinationTableProcessedPartitions") }} (tableName,  completedPartition)
  VALUES
    {% for cur_date in completed_dates %}
      ("{{ tableName }}", DATE("{{ cur_date }}"))
      {%- if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}



{% macro dest_dates_missing(tableName, start_date=none, end_date=none) %}
  -- depends_on: ref('DestinationTableProcessedPartitions')
  {% set destPartitions = ref('DestinationTableProcessedPartitions') %}

  {% if not execute or
        not adapter.already_exists(destPartitions.schema, destPartitions.table) %}
    {{ return('-- TO BE REPLACED AT RUNTIME') }}
  {% endif %}

  {%- call statement('missing_dest_partitions', fetch_result=True) -%}
    WITH
    emailSentPartitions AS (
      SELECT DISTINCT
        _PARTITIONDATE AS partitionDate
      FROM `some-source-project`.DailyUpdates.SomeSourceTable
    ),
    destPartitions AS (
      SELECT DISTINCT
        completedPartition
      FROM {{ ref('DestinationTableProcessedPartitions') }}
      WHERE tableName = '{{ tableName }}'
    )

    SELECT partitionDate FROM emailSentPartitions
    WHERE partitionDate NOT IN (SELECT * FROM destPartitions)
        {% if start_date -%}
          AND partitionDate BETWEEN DATE("{{ start_date }}") AND DATE("{{ end_date }}")
        {%- endif %}
    ORDER BY partitionDate
  {%- endcall -%}

  {{ return(load_result('missing_dest_partitions').table.columns['partitionDate'].values()) }}
{% endmacro %}
