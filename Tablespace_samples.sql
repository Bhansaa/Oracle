                     **********************************************
                          check undo tablespace space
                     *********************************************
                        
                        
SELECT a.tablespace_name,
SIZEMB,
USAGEMB,
(SIZEMB - USAGEMB) FREEMB
FROM ( SELECT SUM (bytes) / 1024 / 1024 SIZEMB, b.tablespace_name
FROM dba_data_files a, dba_tablespaces b
WHERE a.tablespace_name = b.tablespace_name AND b.contents like 'UNDO'
GROUP BY b.tablespace_name) a,
( SELECT c.tablespace_name, SUM (bytes) / 1024 / 1024 USAGEMB
FROM DBA_UNDO_EXTENTS c
WHERE status <> 'EXPIRED'
GROUP BY c.tablespace_name) b
WHERE a.tablespace_name = b.tablespace_name;

select u.tablespace_name tablespace, u.status, sum(u.bytes)/1024/1024 sum_in_mb, count(u.segment_name) seg_cnts 
from dba_undo_extents u  group by u.tablespace_name, u.status order by 1,2



            ***********************************************
                check tablespace size
            ***********************************************
            
            

 SELECT tablespace_name
  , CASE WHEN TRUNC((max_mb - (total_mb - free_mb)) / max_mb * 100, 2) < 10 THEN 'ALERT' END AS alert_flag
  , TRUNC((max_mb - (total_mb - free_mb)) / max_mb * 100, 2) AS pct_free_mb
  , TRUNC((max_mb - (total_mb - free_mb)), 2) AS max_free_mb
  , TRUNC(max_mb, 2) AS max_mb
  , TRUNC(total_mb, 2) AS total_mb
  , TRUNC(free_mb, 2) AS free_mb
FROM
  ( SELECT tablespace_name
      , ( SELECT SUM(BYTES) / 1048576 AS free_mb
          FROM dba_free_space
          WHERE tablespace_name = dba_data_files.tablespace_name) AS free_mb
      , SUM(BYTES) / 1048576 AS total_mb
      , SUM(CASE autoextensible WHEN 'YES' THEN maxbytes ELSE BYTES END) / 1048576 AS max_mb
    FROM dba_data_files
    GROUP BY tablespace_name )
ORDER BY 3
;



*******************************************************************************************************************
  -- 3. Check table fragmentations and generate shrink table statements 

-- Ref: https://orahow.com/how-to-find-and-remove-table-fragmentation-in-oracle-database/ 

-- Recommendation: If you find more than 20% fragmentation then you can proceed for de-fragmentation 
********************************************************************************************************************

WITH u AS (SELECT 'RFARCH' AS userid FROM DUAL)
  SELECT table_name,
         tablespace_name,
         partitioned,
         last_analyzed,
         (SELECT ROUND (SUM (BYTES / 1024 / 1024), 2)     size_mb
            FROM user_segments
           WHERE     segment_type IN ('TABLE', 'TABLE PARTITION')
                 AND segment_name = all_tables.table_name)
             AS segment_size_mb,
         ROUND ((blocks * 8) / 1024, 2)
             size_mb,
         ROUND ((num_rows * avg_row_len / 1024) / 1024, 2)
             actual_data_mb,
         (  ROUND ((blocks * 8) / 1024, 2)
          - ROUND ((num_rows * avg_row_len / 1024) / 1024, 2))
             wasted_space_mb,
         CASE
             WHEN ROUND ((blocks * 8) / 1024, 2) > 100
             THEN
                   ROUND (
                       (  ROUND (
                              (  (blocks * 8 / 1024)
                               - (num_rows * avg_row_len / 1024 / 1024)),
                              2)
                        / ROUND (((blocks * 8 / 1024)), 2)),
                       4)
                 * 100
             ELSE
                 0
         END
             AS percentage,
            'ALTER TABLE '
         || u.userid
         || '.'
         || table_name
         || ' ENABLE ROW MOVEMENT;'
         || CHR (13)
         || CHR (10)
         || --'ALTER TABLE ' || u.userid || '.' || table_name || ' SHRINK SPACE CASCADE;' || CHR(13) || CHR(10) ||

            'ALTER TABLE '
         || u.userid
         || '.'
         || table_name
         || ' SHRINK SPACE;'
         || CHR (13)
         || CHR (10)
         || 'ALTER TABLE '
         || u.userid
         || '.'
         || table_name
         || ' DISABLE ROW MOVEMENT;'
             AS shrink_table_sql
    FROM all_tables JOIN u ON u.userid = all_tables.owner
   WHERE (ROUND ((blocks * 8), 2) > ROUND ((num_rows * avg_row_len / 1024), 2))
ORDER BY 5 DESC NULLS LAST;


            ***************************************
                Query to check long running SQL
           ****************************************
          
           
SELECT s.sid,
         s.serial#,
       s.machine,
       ROUND(sl.sofar/sl.totalwork*100, 2) progress_pct,
       ROUND(sl.elapsed_seconds/60) || ':' || MOD(sl.elapsed_seconds,60) elapsed,
       ROUND(sl.time_remaining/60) || ':' || MOD(sl.time_remaining,60) remaining
FROM   v$session s,
       v$session_longops sl
WHERE  s.sid     = sl.sid
AND    s.serial# = sl.serial#;


        ************************************
              Query to check Table locks
        ************************************

select lo.session_id,lo.oracle_username,lo.os_user_name,
lo.process,do.object_name,
decode(lo.locked_mode,0, 'None',1, 'Null',2, 'Row Share (SS)',
3, 'Row Excl (SX)',4, 'Share',5, 'Share Row Excl (SSX)',6, 'Exclusive',
to_char(lo.locked_mode)) mode_held
from v$locked_object lo, dba_objects do
where lo.object_id = do.object_id
order by 1,5;
