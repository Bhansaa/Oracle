## Handling the Predefined exception

```sql
declare
  v_name varchar2(6);
begin
  select first_name into v_name from employees where employee_id = 50;
  dbms_output.put_line('Hello');
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
end;
/
```
## Handling multiple exceptions
```sql

declare
  v_name varchar2(6);
  v_department_name varchar2(100);
begin
  select first_name into v_name from employees where employee_id = 100;
  select department_id into v_department_name from employees where first_name = v_name;
  dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
  when too_many_rows then
    dbms_output.put_line('There are more than one employees with the name '|| v_name);
    dbms_output.put_line('Try with a different employee');
end;
/
```

## when others then example

```sql

declare
  v_name varchar2(6);
  v_department_name varchar2(100);
begin
  select first_name into v_name from employees where employee_id = 103;
  select department_id into v_department_name from employees where first_name = v_name;
  dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
  when too_many_rows then
    dbms_output.put_line('There are more than one employees with the name '|| v_name);
    dbms_output.put_line('Try with a different employee');
  when others then
    dbms_output.put_line('An unexpected error happened. Connect with the programmer..');
end;
/
```
## sqlerrm & sqlcode example

```sql
declare
  v_name varchar2(6);
  v_department_name varchar2(100);
begin
  select first_name into v_name from employees where employee_id = 103;
  select department_id into v_department_name from employees where first_name = v_name;
  dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
  when too_many_rows then
    dbms_output.put_line('There are more than one employees with the name '|| v_name);
    dbms_output.put_line('Try with a different employee');
  when others then
    dbms_output.put_line('An unexpected error happened. Connect with the programmer..');
    dbms_output.put_line(sqlcode || ' ---> '|| sqlerrm);
end;
/
```
## Inner block exception example

```sql
declare
  v_name varchar2(6);
  v_department_name varchar2(100);
begin
  select first_name into v_name from employees where employee_id = 100;
  begin
    select department_id into v_department_name from employees where first_name = v_name;
    exception
      when too_many_rows then
      v_department_name := 'Error in department_name';
  end;
  dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the selected id');
  when too_many_rows then
    dbms_output.put_line('There are more than one employees with the name '|| v_name);
    dbms_output.put_line('Try with a different employee');
  when others then
    dbms_output.put_line('An unexpected error happened. Connect with the programmer..');
    dbms_output.put_line(sqlcode || ' ---> '|| sqlerrm);
end;
/
select * from employees where first_name = 'Steven';

```


## Handling the NON-Predefined exception
```sql
Non-predefined Exceptions
.   Unnamed Exceptions
•   We cannot trap with the error codes
•   We declare exceptions with the error code
SAMPLE --> exception_name EXCEPTION;  in declare section 

SYNTAX --> PRAGMA EXCEPTION_INIT(exception_name, error_code)

What is PRAGMA?
    It is keyword that tells compiler about exception name and code

• What does exception_init do?
    It tells compiler that this code referes to expection defined


EXAMLPLE -->

declare
  my_exception EXCEPTION;
  PRAGMA EXCEPTION_INIT (my_exception,-01407);
begin
  UPDATE employees
    SET email=null
  WHERE employee_id = 100;
exception
    when   my_exception then
    dbms_output.put_line('cannot update null in email');
end;

```
## Handling the USER-Predefined exception

.You need to handle some exceptions about your business.
. cannot be called out of the block
.These exceptions are not an error for the database.
• Define a user-defined exception and raise it.
. There are no error codes for user defined exceptions 
syntax --> exception_name EXCEPTION;
explicity raise exception --> RAISE exception_name;

You can raise any type of exceptions with RAISE statement.
```sql
example-->

declare
  my_exception    EXCEPTION;
  v_salary_check  PLS_INTEGER;
begin
  SELECT salary INTO v_salary_check FROM
    employees
  WHERE employee_id = 100;

  IF v_salary_check>20000 THEN
   raise my_exception;
  END IF;

  IF v_salary_check < 20000 THEN
    dbms_output.put_line('This salary is OK');
  END IF;
exception
    when   my_exception then
    dbms_output.put_line('This salary is too high');

end;

```
