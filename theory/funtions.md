## CREATING AND USING FUNCTIONS
  * Functions are pretty similar with the procedures
  * Functions can get IN and OUT parameters
  * Functions must RETURN a value
  * Functions are very similar with procedures on creation,except its usage
  * FUntions cannot be called diretly like procedures
  * Functions can be used within a select statement
  * You can assign a function to a variable.
  * if more than 1 value is coming from fruntion use record/plsql table instead of OUT parameter

_SYNTAX_: 
```sql
CREATE [OR REPLACE] FUNCTION function_name
[(parameter_name [IN | OUT IN OUT] type DEFAULT value expression
[....])] RETURN return_data_type {IS | AS)

```
## Differences and Similarities of Functions&Procedures
  
  * Procedures are executed within a begin-end block or with execute command.
  * Functions are used within an SQL Query or assigned to some variable.
  * FUntions are not used standalone as procedures
  * We can pass IN&OUT parameters to both (but using OUT is not recommended)
  * Procedures does not return a value,but functions return

*EXAMPLE*
```sql
 CREATE OR REPLACE FUNCTION
    GET_SAL_COMM
   RETURN number
     as 
    lv_avg_sal number;
   BEGIN
        SELECT salary*commission_pct INTO lv_avg_sal FROM employees where employee_id=161;
            return lv_avg_sal;
   END;
   
   ```
   
   execute funtions:
   
   ```sql
   
    1) SELECT GET_SAL_COMM FROM   dual; 
   
    2) 
   begin
        DBMS_OUTPUT.PUT_LINE(GET_SAL_COMM); 
   end;
   ```
