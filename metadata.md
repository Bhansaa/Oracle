

 ***********************************
       1. check partiotions
 ***********************************
 
 SELECT * FROM
    DBA_PART_TABLES
   WHERE owner in UPPER('RFARCH')
   
   
  ***********************************
      2.table_size
  ***********************************
  
  SELECT * FROM (
  SELECT
     tablespace_name,object_type, table_name, ROUND(bytes)/1024/1024 AS MB_SIZE,  
   --  sum(ROUND(bytes)/1024/1024/1024 AS GB_SIZE ,
    ROUND(Sum(bytes/1024/1024/1024) OVER (PARTITION BY table_name)) AS total_table_gb
  FROM (
    -- Tables
    SELECT owner, segment_name AS object_name, 'TABLE' AS object_type,
          segment_name AS table_name, bytes,
          tablespace_name, extents, initial_extent
    FROM   dba_segments
    WHERE  segment_type IN ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION')
  )
  WHERE owner in UPPER('RFARCH')
    AND lower(table_name) like 'b_bpo%'
    )
WHERE mb_size >= 0
ORDER BY total_table_gb DESC, mb_size DESC


**************************************
   3.compression
**************************************

https://oracle-base.com/articles/9i/compressed-tables-9i#:~:text=If%20you%20want%20to%20compress,for%20a%20period%20of%20time.

--Check compression status
SELECT TABLE_NAME, COMPRESSION FROM DBA_TABLES
WHERE UPPER(TABLE_NAME) LIKE 'B_BPO%'
AND COMPRESSION!='DISABLED';


Sample --> ALTER TABLE RFARCH.B_BPOGROUP_BINSKU_HIS MOVE ROW STORE COMPRESS ADVANCED;

For Partitions Tables:

Alter table RFARCH.STK_STOCK_TAKE_RESULT_AUDIT
move partition SYS_P37023 row store compress advanced;

AFTER COMPRESSION 
![after compression](https://user-images.githubusercontent.com/87269794/187385156-11478e42-609b-4d5d-a688-0a15fc643a49.png)

BEFORE COMPRESSION:

NOCOMPRESS
