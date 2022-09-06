# WHERE CURRENT OF CLAUSE:

	--> used with for update cleause
	--> when update/delete one by one --> to do it FAST
	--> used with update/delete command in end.
	--> it is faster as it fecthed fdirectly rowid
	--> cannot be used with group funtions and join in cursors
	--> used when only one table is used in cursors
	-->EXAMPLE
  
```sql	
	DECLARE
    CURSOR c_country
        IS
       SELECT * FROM    
        countries
       WHERE REGION_ID=3
       for update;    
	BEGIN

    for r in c_country loop
        UPDATE countries
            SET country_name='INDIA'
          -- WHERE region_id=r.region_id;    --norammly
            WHERE CURRENT OF c_country;      --it will get the row_id to update
      end loop;
      
	END;
  ```
