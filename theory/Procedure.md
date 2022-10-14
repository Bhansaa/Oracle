## Using IN & OUT Parameters (Code Samples)

```sql
-----------------Creating a procedure with the IN parameters
create or replace procedure increase_salaries (v_salary_increase in number, v_department_id pls_integer) as
    cursor c_emps is select * from employees_copy where department_id = v_department_id for update;
    v_old_salary number;
begin
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
    end loop;
    dbms_output.put_line('Procedure finished executing!');
end;
----------------- Creating a procedure with the OUT parameters
create or replace procedure increase_salaries 
    (v_salary_increase in out number, v_department_id pls_integer, v_affected_employee_count out number) as
    cursor c_emps is select * from employees_copy where department_id = v_department_id for update;
    v_old_salary number;
    v_sal_inc number := 0;
begin
    v_affected_employee_count := 0;
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary * v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
      v_affected_employee_count := v_affected_employee_count + 1;
      v_sal_inc := v_sal_inc + v_salary_increase + nvl(r_emp.commission_pct,0);
    end loop;
    v_salary_increase := v_sal_inc / v_affected_employee_count;
    dbms_output.put_line('Procedure finished executing!');
end;
-----------------Another example of creating a procedure with the IN parameter 
CREATE OR REPLACE PROCEDURE PRINT(TEXT IN VARCHAR2) IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(TEXT);
END;
-----------------Using the procedures that has the IN parameters 
begin
 PRINT('SALARY INCREASE STARTED!..');
 INCREASE_SALARIES(1.15,90);
 PRINT('SALARY INCREASE FINISHED!..');
end;
-----------------Using the procedure that has OUT parameters 
declare
  v_sal_inc number := 1.2;
  v_aff_emp_count number;
begin
 PRINT('SALARY INCREASE STARTED!..');
 INCREASE_SALARIES(v_sal_inc,80,v_aff_emp_count);
 PRINT('The affected employee count is : '|| v_aff_emp_count);
 PRINT('The average salary increase is : '|| v_sal_inc || ' percent!..');
 PRINT('SALARY INCREASE FINISHED!..');
end;
```
## CALLING PROCEDURE WITHOUT PARAMETER

```sql
CREATE OR REPLACE PROCEDURE print (text  varchar2 default 'This is print procedure...')
    IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(text); 
END;

--used default keyword to call procedure without paramenter;

BEGIN
    print('hello');
END;
--printed the default value 
BEGIN
    print();
END;
```


## NAMED/Mixed NOTATION and DEFAULT keyword

```sql
CREATE OR REPLACE PROCEDURE add_job (job_id  varchar2 ,job_title varchar2,min_salary number default 1000 ,MAX_SALARY number default null)
    IS
BEGIN
    insert into jobs values (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY);
    print ('The job ' ||JOB_TITLE ||' is inserted');
END;


SELECT * FROM  jobs 

exec add_job('it_dir5','directory',5000,20000);

--NAMED NOTATION  --> allow us to skip parameter independent from position
-- exec procedure (parameter_name => value|expression)

exec add_job('it_dir5','directory',max_salary => 20000);
```
