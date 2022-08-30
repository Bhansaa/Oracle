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
      DBMS_STATS.gather_index_stats('<schema/username>, c_idx.index_name, null, DBMS_STATS.AUTO_SAMPLE_SIZE);  
  END LOOP;  
END LOOP;
EXCEPTION
  WHEN OTHERS THEN
  NULL;
END;


-- generate index rebuild script using below script


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
