------------------------------------------------
              Sample MERGE
------------------------------------------------


MERGE INTO <target_table> t
     USING (SELECT *
              FROM <source_table>
             WHERE dc_code = 303) s        
        ON (t.adj_type=s.adj_type  AND t.reason=s.reason )           ---matching columns
WHEN MATCHED
THEN
    UPDATE SET t.EXT_ADJ_REASON=s.EXT_ADJ_REASON,
               t.REASON_DESC=s.REASON_DESC
           WHERE t.dc_code in (3677,3678)
           AND t.EXT_ADJ_REASON!=s.EXT_ADJ_REASON
WHEN NOT MATCHED
 THEN
 INSERT (COLUMNS) 
  VALUES(source columns);
