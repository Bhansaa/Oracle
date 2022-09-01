#CURSORS:


#EXPLICIT CURSORS:

```sql
DECLARE
    CURSOR c_order IS
        SELECT *
          FROM WMS_ORDER_HEAD
         WHERE order_type = 'CUS' AND status = 'C';

    v_order   c_order%ROWTYPE;
BEGIN
    OPEN c_order;

    LOOP
        FETCH c_order INTO v_order;

        EXIT WHEN c_order%NOTFOUND;          --use this to avoid infinite loop
        DBMS_OUTPUT.put_line (v_order.order_no);
    END LOOP;

    CLOSE c_order;
END;

------for loop-----------------------

DECLARE
    CURSOR c_order IS
        SELECT *
          FROM WMS_ORDER_HEAD
         WHERE order_type = 'CUS' AND status = 'C';
BEGIN
    FOR i IN c_order
    LOOP
        DBMS_OUTPUT.put_line (i.order_no);
    END LOOP;
END;

--------Cursor with parameters---------------


DECLARE
    CURSOR c_order (p_order_no VARCHAR2)
    IS
        SELECT *
          FROM WMS_ORDER_HEAD
         WHERE order_type = 'CUS' AND status = 'C' AND order_no = p_order_no;

    v_order   c_order%ROWTYPE;
BEGIN
    OPEN c_order ( :b_order_no); ---take bind varaibles to define same parameter in all code

    FETCH c_order INTO v_order;

    DBMS_OUTPUT.put_line (v_order.ext_order_no);

    CLOSE c_order;

    -- this is bawith basic loop
    OPEN c_order ( :b_order_no);

    LOOP
        FETCH c_order INTO v_order;

        EXIT WHEN c_order%NOTFOUND;
        DBMS_OUTPUT.put_line (v_order.cust_name || v_order.CUST_ADDR_3);
    END LOOP;

    CLOSE c_order;

    --this is with for loop
    FOR i IN c_order ( :b_order_no1)
    LOOP
        DBMS_OUTPUT.put_line (v_order.cust_name || v_order.CUST_ADDR_3);
    END LOOP;
END;

----------CURSOR ATTRIBUTES--------------------

--> %FOUND
--> %NOTFOUND
--> %ISOPEN
--> %ROWCOUNT

DECLARE
    CURSOR c_order IS
        SELECT *
          FROM WMS_ORDER_HEAD
         WHERE     order_type = 'CUS'
               AND status = 'C'
               AND order_no IN ('0000070915', 0000070895, '0000070916');

    v_order   c_order%ROWTYPE;
BEGIN
    IF NOT c_order%ISOPEN
    THEN
        OPEN c_order;

        DBMS_OUTPUT.put_line ('Cursor is open');
    END IF;

    DBMS_OUTPUT.put_line (c_order%ROWCOUNT);

    FETCH c_order INTO v_order;

    DBMS_OUTPUT.put_line (c_order%ROWCOUNT || ':' || v_order.order_no);

    FETCH c_order INTO v_order;

    DBMS_OUTPUT.put_line (c_order%ROWCOUNT || ':' || v_order.order_no);

    CLOSE c_order;


    OPEN c_order;

    LOOP
        FETCH c_order INTO v_order;

        EXIT WHEN c_order%NOTFOUND OR c_order%ROWCOUNT > 1;
        DBMS_OUTPUT.put_line (v_order.order_no);
    END LOOP;

    CLOSE c_order;
END;

```
