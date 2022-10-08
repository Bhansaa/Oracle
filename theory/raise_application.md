# RAISE APPLICATION Error

.Sometimes you want to raise an exception out of the block
.raise_application_error raises the error to the caller
.can be used in both block or exception
syntax --> raise_application_error(error_number,error_message[,TRUE FALSE]); --true /false is optional where false is used to hide all other error message and              true     shows all

What is the error stack? 
Will stop execution of the application once exception is eaised
Error number must be between -20000 and -20999 
Error Message will be up to 2048 bytes long
```sql
example-->

----------------- Handling the exception
declare
  my_exception    EXCEPTION;
  v_salary_check  PLS_INTEGER;
begin
  SELECT salary INTO v_salary_check FROM
    employees
  WHERE employee_id = 100;
  
  IF v_salary_check>20000 THEN
  -- raise_application_error(-20001,'This salary is too high');
  raise my_exception;
  END IF;
  
  IF v_salary_check < 20000 THEN
    dbms_output.put_line('This salary is OK');
  END IF;
exception
    when   my_exception then
    dbms_output.put_line('This salary is too high');
  raise_application_error(-20001,'This salary is too high');
end;
```
