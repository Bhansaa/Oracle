---------------------------------------------------------
               sort data with rownum()
---------------------------------------------------------

SELECT
 *
FROM
    (SELECT
            ROW_NUMBER() OVER(ORDER BY pickdetail_key ) AS rnum,a.*FROM wms_pick_manifest_dtl_temp_20220403 a
    )WHERE  rnum > 11000    AND rnum <= 11000
       
