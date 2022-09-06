# REF CURSORS:

## points to note:
 --> just as pointers --> hold memory addresses of actual variables
 --> REFERENCE CURSORS(REF CURSORS)
 --> You can use a cursor for multiple queries
 
 >>>We cannot:
 	> Assing null values
 	> Use in table-view create codes
 	> Store in collections
 	> Compare
 
 >>>There two types of reference cursors
		> Strong (restrictive)cursors
		> Weak(nonrestrictive)cursors.

		> if no return type is mentined then WEAK otherwise STRONG
		> IF strong cursor we can also create recordtype for that
		> for dyanamic queries we use weak ref cursors
		> WEAK can have bind variables
		> BUILT in weak ref--> sys_refcursor
		
 -->  SYNTAX:
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
                       WHERE region_id = 3;
 
    LOOP                                      --use basi loop as for will again open cursor leading to error
        FETCH vc_Count INTO r_count;

        EXIT WHEN vc_Count%NOTFOUND;
        DBMS_OUTPUT.put_line (r_count.country_ID);
    END LOOP;
    CLOSE vc_Count;
    
END;

declare
  type ty_emps is record (e_id number, 
                         first_name employees.last_name%type, 
                         last_name employees.last_name%type,
                         department_name departments.department_name%type);
 r_emps ty_emps;
 type t_emps is ref cursor;
 rc_emps t_emps;
 r_depts departments%rowtype;
 --r t_emps%rowtype;
 q varchar2(200);
begin
  q := 'select employee_id,first_name,last_name,department_name 
                      from employees join departments using (department_id)
                      where department_id = :t';
  open rc_emps for q using '50';
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
            ' is at the department of : '|| r_emps.department_name );
    end loop;
  close rc_emps;
  
  open rc_emps for select * from departments;
    loop
      fetch rc_emps into r_depts;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_depts.department_id|| ' ' || r_depts.department_name);
    end loop;
  close rc_emps;
end;
---------------sys_refcursor example
declare
  type ty_emps is record (e_id number, 
                         first_name employees.last_name%type, 
                         last_name employees.last_name%type,
                         department_name departments.department_name%type);
 r_emps ty_emps;
-- type t_emps is ref cursor;
 rc_emps sys_refcursor;
 r_depts departments%rowtype;
 --r t_emps%rowtype;
 q varchar2(200);
begin
  q := 'select employee_id,first_name,last_name,department_name 
                      from employees join departments using (department_id)
                      where department_id = :t';
  open rc_emps for q using '50';
    loop
      fetch rc_emps into r_emps;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_emps.first_name|| ' ' || r_emps.last_name|| 
            ' is at the department of : '|| r_emps.department_name );
    end loop;
  close rc_emps;
  
  open rc_emps for select * from departments;
    loop
      fetch rc_emps into r_depts;
      exit when rc_emps%notfound;
      dbms_output.put_line(r_depts.department_id|| ' ' || r_depts.department_name);
    end loop;
  close rc_emps;
end;
```
