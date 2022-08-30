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
