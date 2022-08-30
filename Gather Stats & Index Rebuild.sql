                                          *************************************************
                                                      Gather Stats & Index Rebuild
                                          *************************************************

BEGIN
FOR c_table IN (select table_name from user_tables where table_name in (<>table_name<>))
LOOP  
  DBMS_STATS.gather_table_stats('<schema/username>', c_table.table_name);
  /* Analyze related indexes */
  FOR c_idx IN (select index_name from user_indexes where table_name = c_table.table_name)
  LOOP
      DBMS_STATS.gather_index_stats(<schema/username>, c_idx.index_name, null, DBMS_STATS.AUTO_SAMPLE_SIZE);  
  END LOOP;  
END LOOP;
EXCEPTION
  WHEN OTHERS THEN
  NULL;
END;

                                ******************************************************
                                   generate index rebuild script using below script
                                 ******************************************************


select idx.table_name, idx.index_name
  , idp.partition_name
  , 'ALTER INDEX ' || idx.index_name || ' REBUILD ONLINE NOLOGGING;' as rebuild_statement
from user_indexes idx
  left join user_ind_partitions idp on idp.index_name = idx.index_name
where idx.table_name in 
  ( select table_name
    from user_tables
    where table_name in 
      (<table_name>))
order by 1, 2, 3;
                                    
                                    
                                    **********************************************
                                         check index size and rebuild
                                    **********************************************
                                    
                                    
 WITH u AS (SELECT 'WMSPRD' AS userid FROM DUAL)
  SELECT idx.table_name,
         idx.index_name,
         idx.tablespace_name,
         idp.partition_name,
         idx.index_type,
         idx.partitioned,
         idx.num_rows,
         idx.sample_size,
         idx.last_analyzed,
         (SELECT LISTAGG (column_name, ', ')
                     WITHIN GROUP (ORDER BY column_position)
            FROM all_ind_columns
           WHERE     index_owner = u.userid
                 AND table_name = idx.table_name
                 AND table_owner = u.userid
                 AND index_name = idx.index_name)      AS index_cols,
         (SELECT ROUND (BYTES / 1024 / 1024, 3)
            FROM dba_segments
           WHERE     OWNER = u.userid
                 AND segment_type = 'INDEX'
                 AND segment_name = idx.index_name)    AS index_size_mb,
         (SELECT ROUND (BYTES / 1024 / 1024, 3)
            FROM dba_segments
           WHERE     OWNER = u.userid
                 AND segment_type = 'TABLE'
                 AND segment_name = idx.table_name)    AS table_size_mb,
         CASE
             WHEN idx.partitioned = 'NO'
             THEN
                    'ALTER INDEX '
                 || u.userid
                 || '.'
                 || idx.index_name
                 || ' REBUILD ONLINE NOLOGGING;'
             ELSE
                 NULL
         END                                           AS exec_rebuild_idx_sql,
         CASE
             WHEN idx.partitioned = 'YES'
             THEN
                    'ALTER INDEX '
                 || u.userid
                 || '.'
                 || idx.index_name
                 || ' REBUILD PARTITION '
                 || idp.partition_name
                 || ' ONLINE NOLOGGING;'
             ELSE
                 NULL
         END                                           AS exec_rebuild_idx_partition_sql
    FROM all_indexes idx
         JOIN u ON u.userid = idx.owner
         LEFT JOIN all_ind_partitions idp
             ON idp.index_owner = idx.owner AND idp.index_name = idx.index_name
   WHERE idx.num_rows <> 0 
   AND lower(idx.table_name) in ('wms_dc_item_fifo','wms_bin_item_fifo','wms_bin_item_link','wms_dc_item_soh','wms_ship_advice_dtl','wms_pick_manifest_dtl','wms_pick_hdr','wms_pick_dtl','wms_ecom_manifest_dtl') 
   AND idx.index_type NOT IN ('FUNCTION-BASED NORMAL')
ORDER BY idx.table_name, idx.index_name, idp.partition_name;
