# REF CURSORS:

 --> just as pointers --> hold memory addresses of actual variables
 --> REFERENCE CURSORS(REF CURSORS)
 --> You can use a cursor for multiple queries
 --> We cannot:
		> Assing null values
		> Use in table-view create codes
		> Store in collections
		> Compare
 --> How do we use ref cursors?
 --> There two types of reference cursors
		> Strong (restrictive)cursors
		> Weak(nonrestrictive)cursors.
 -->  SYNTAX:
		> if no return type is mentined then WEAK otherwise STRONG
		> IF strong cursor we can also create recordtype for that
		> for dyanamic queries we use weak ref cursors
		> WEAK can have bind variables
		> BUILT in weak ref--> sys_refcursor
type cursor_type_name is ref cursor [return return_type]

```sql
 --> EXAMPLE STRONG ONE:
	>
DECLARE
    TYPE rc_country IS REF CURSOR
        RETURN countries%ROWTYPE;          -----syntax ref cursors

    vc_Count   rc_country;                  -----cursor variable 

    r_count    vc_Count%ROWTYPE;            -----record type to fecth data in it
BEGIN
    OPEN vc_Count FOR SELECT *              --open curosr sntax
                        FROM countries
                       WHERE region_id = 3;
 
    LOOP                                      --use basi loop as for will again open cursor leading to error
        FETCH vc_Count INTO r_count;

        EXIT WHEN vc_Count%NOTFOUND;
        DBMS_OUTPUT.put_line (r_count.country_name);
    END LOOP;

    CLOSE vc_Count;
END;

 --> EXAMPLE 2:  use ref cursors for mutiple times:
 
DECLARE
    TYPE rc_country IS REF CURSOR
        RETURN countries%ROWTYPE;          -----syntax ref cursors

    vc_Count   rc_country;                  -----cursor variable 

    r_count    vc_Count%ROWTYPE;            -----record type to fecth data in it
BEGIN
    OPEN vc_Count FOR SELECT *              --open curosr sntax
                        FROM countries
                       WHERE region_id = 3;
 
    LOOP                                      --use basi loop as for will again open cursor leading to error
        FETCH vc_Count INTO r_count;

        EXIT WHEN vc_Count%NOTFOUND;
        DBMS_OUTPUT.put_line (r_count.country_name);
    END LOOP;
    CLOSE vc_Count;
    DBMS_OUTPUT.put_line ('--------------------------------------------------');
     OPEN vc_Count FOR SELECT *              --open curosr sntax
                        FROM countries
                       WHERE region_id = 3;
 
    LOOP                                      --use basi loop as for will again open cursor leading to error
        FETCH vc_Count INTO r_count;

        EXIT WHEN vc_Count%NOTFOUND;
        DBMS_OUTPUT.put_line (r_count.country_ID);
    END LOOP;
    CLOSE vc_Count;
    
END;


 --> EXAMPLE WEAK ONE:
 
DECLARE
    TYPE rc_country IS REF CURSOR;
       -- RETURN countries%ROWTYPE;          -----no return type 

    vc_Count   rc_country;                  -----cursor variable 

    r_count    countries%ROWTYPE;            -----record type to fecth data in it
BEGIN
    OPEN vc_Count FOR SELECT *              --open curosr sntax
                        FROM countries
                       WHERE region_id = 3;
 
    LOOP                                      --use basi loop as for will again open cursor leading to error
        FETCH vc_Count INTO r_count;

        EXIT WHEN vc_Count%NOTFOUND;
        DBMS_OUTPUT.put_line (r_count.country_name);
    END LOOP;
    CLOSE vc_Count;
    DBMS_OUTPUT.put_line ('--------------------------------------------------');
     OPEN vc_Count FOR SELECT *              --open curosr sntax
                        FROM countries
                       WHERE region_id = 3;a
 
    LOOP                                      --use basi loop as for will again open cursor leading to error
        FETCH vc_Count INTO r_count;

        EXIT WHEN vc_Count%NOTFOUND;
        DBMS_OUTPUT.put_line (r_count.country_ID);
    END LOOP;
    CLOSE vc_Count;
    
END;
```
