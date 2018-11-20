

{{ config_incremental(partition_by='DATE(fakeEntry)') }}

SELECT CURRENT_TIMESTAMP() AS fakeEntry
