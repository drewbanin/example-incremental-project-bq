
-- A list of partitions that have been successfully processed, one row per table per ingestion.
-- This table is inserted into via POST-HOOKs in our other tables.

{{ config(
    materialized='incremental',
    sql_where='TRUE',
    partition_by='completedPartition',
    cluster_by='tableName'
) }}



-- This fake query generates an empty table with the correct schema.
WITH fakeData AS (
  SELECT
    '`fakeProject`.`fakeDataset`.`fakeTable`' AS tableName,
    DATE('2018-10-31') AS completedPartition
)
SELECT * FROM fakeData
WHERE FALSE
