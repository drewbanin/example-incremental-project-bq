

{% set missing_dest_dates =
    dest_dates_missing(this,
                       start_date=var('source_start_date', none),
                       end_date=var('source_end_date', none)) %}

-- depends_on: {{ ref('DestinationTableProcessedPartitions') }}
{{ config({
    'materialized': 'incremental',
    'sql_where': 'TRUE',

    'post-hook': post_hook_mark_dest_dates_complete(this, missing_dest_dates)
}) }}


SELECT CURRENT_TIMESTAMP() AS fakeEntry
