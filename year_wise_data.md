-------------------------------------------------------------
         to get data year and month wise format
-------------------------------------------------------------



```sql

  SELECT COUNT (*),
         TO_CHAR (CREATED_DATETIME, 'MON YYYY')     AS YEAR,
         MIN (CREATED_DATETIME)
    FROM WMS_GTM_LABELS
   WHERE TRUNC (CREATED_DATETIME) <= '31-12-22'
GROUP BY TO_CHAR (CREATED_DATETIME, 'YYYY')
ORDER BY TO_CHAR (CREATED_DATETIME, 'YYYY') DESC
 
/* Formatted on 30/08/2022 11:00:44 (QP5 v5.381) */
  SELECT TO_CHAR (TRUNC (created_datetime, 'MM'), 'MON YYYY') month, COUNT (*)
    FROM MW_RF_PICK_CONFIRM
   WHERE     dc_code IN (901, 905, 904)
         AND TRUNC (created_datetime) BETWEEN '26/JUL/2021' AND '31/MAR/2022'
GROUP BY TO_CHAR (TRUNC (created_datetime, 'MM'), 'MON YYYY')
ORDER BY TO_CHAR (TRUNC (created_datetime, 'MM'), 'MON YYYY') DESC, dc_code;
 ```
