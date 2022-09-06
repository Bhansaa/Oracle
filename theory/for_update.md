For Update clause

	--> WHen you update a rwo,it lock others
	--> for update clause locks selected rows--free up after commit /rollback
	--> written at last line of cursor.
	--> nowait option will terminate execution and end program if there is a lock on same row an dthen we need to try later 
	--> Default option is ---> wait (use specifc seconds after that it return error and end)
	--> can use for update only on selected tables in case of cursor have joins by writing column names
	--> SYNTAX
	

```sql
declare
  cursor c_emps is select employee_id,first_name,last_name,department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100,101,102)
      for update;
begin
  /* for r_emps in c_emps loop
    update employees_copy set phone_number = 3
      where employee_id = r_emps.employee_id; 
  end loop; */
  open c_emps;
end;
--------------- example of wait with second
declare
  cursor c_emps is select employee_id,first_name,last_name,department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100,101,102)
      for update of employees_copy.phone_number, 
      departments.location_id wait 5;
begin
  /* for r_emps in c_emps loop
    update employees_copy set phone_number = 3
      where employee_id = r_emps.employee_id; 
  end loop; */
  open c_emps;
end;
---------------example of nowait
declare
  cursor c_emps is select employee_id,first_name,last_name,department_name
      from employees_copy join departments using (department_id)
      where employee_id in (100,101,102)
      for update of employees_copy.phone_number, 
      departments.location_id nowait;
begin
  /* for r_emps in c_emps loop
    update employees_copy set phone_number = 3
      where employee_id = r_emps.employee_id; 
  end loop; */
  open c_emps;
end;
```
