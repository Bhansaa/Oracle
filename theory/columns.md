#COLUMNS:

## Defining Columns

  A table in Oracle Database can have up to 1,000 columns. You define these when you create a table. You can also add them to existing tables.
  Every column has a data type. The data type determines the values you can store in the column and the operations you can do on it. The following statement creates a table with three columns. One varchar2, one number, and one date:
  
  ```sql
  create table this_table_has_three_columns (
  this_is_a_character_column varchar2(100),
  this_is_a_number_column    number,
  this_is_a_date_column      date);
```

Viewing Column Information

You can find details about the columns in your user's tables by querying user_tab_columns.
This query finds the name, type, and limits of the columns in this schema:

```sql
select table_name, column_name, data_type, data_length, data_precision, data_scalefrom   user_tab_columns;


select column_name, data_type, data_length
from   user_tab_columns
where  table_name = 'TOYS';

```

##Oracle Database has three key character types:
   --> varchar2
   --> char
   --> clob
   
You use these to store general purpose text.

##Varchar2
This stores variable length text. You need to specify an upper limit for the size of these strings.
In Oracle Database 11.2 and before, the maximum you can specify is 4,000 bytes. 
From 12.1 you can increase this length to 32,767.

##Char
These store fixed-length strings. If the text you insert is shorter than the max length for the column, the database right pads it with spaces.
The maximum size of char is 2,000 bytes.
Only use char if you need fixed-width data. In the vast majority of cases, you should use varchar2 for short strings.

##Clob
If you need to store text larger than the upper limit of a varchar2, use a clob. 
This is a character large object. It can store data up to (4 gigabytes - 1) * (database block size).
In a default Oracle Database installation this is 32Tb!

The following statement creates a table with various character columns:
```sql
create table character_data (
  varchar_10_col   varchar2(10),
  varchar_4000_col varchar2(4000),
  char_10_col      char(10),
  clob_col         clob
);

select column_name, data_type, data_length
from   user_tab_columnswhere  table_name = 'CHARACTER_DATA';

```
Each of these types also has an N variation; nchar, nvarchar2, and nclob. These store Unicode-only data. It's rare you'll use these data types.

##Numeric Data Types

The built-in numeric data types for Oracle Database are:
 --> number
 --> float
 --> binary_float
 --> binary_double
 
You use these to store numeric values, such as prices, weights, etc.

##Number
This is the most common numeric data type. The format of it is:
number ( precision, scale )
The precision states the number of significant figures allowed.
Scale determines the digits from the decimal point. The database rounds values that exceed the scale.
For example:


Min Value
Max Value
number ( 3, 2 )
-9.99
9.99
number ( 3, -2 )
-99900
99900
number ( 5 )
-99999
99999

If you omit the precision and scale, the number defaults to the maximum range and precision.

##Float

This is a subtype of number. You can use it to store floating-point numbers. But we recommend that you use binary_float or binary_double instead.

##Binary_float & Binary_double
These are floating point numbers. They can have any number of digits after the decimal point.
Binary_float is a 32-bit, single-precision floating-point number. Binary_double is a 64-bit, double-precision floating-point. The limits for these data types are:
Value                       binary_float     binary_double 
 Maximum positive value     3.40282E+38F     1.79769313486231E+308
Minimum positive value      1.17549E-38F     2.22507485850720E-308

These also allow you to store the special values infinity and NaN (not a number).

##ANSI Numeric Types
Oracle Database also supports ANSI numeric types, which map back to built-in types. For example:
integer => number(*, 0)
real => float(63)
The following creates a table with various numeric data types:
```sql
create table numeric_data (
  number_3_sf_2_dp  number(3, 2),
  number_3_sf_2     number(3, -2),
  number_5_sf_0_dp  number(5, 0),
  integer_col       integer,
  float_col         float(10),
  real_col          real,
  binary_float_col  binary_float,
  binary_double_col binary_double
);

select column_name, data_type, data_length, data_precision, data_scale
from   user_tab_columns
where  table_name = 'NUMERIC_DATA';
```
Note that the columns defined with ANSI types (integer_col & real_col) are mapped to the Oracle type.

##Datetime and Interval Data Types
Oracle Database has the following datetime data types:
 --> date
 --> timestamp
 --> timestamp with time zone
 --> timestamp with local time zone

You use these to store when events happened or are planned to happen. Always use one of the above types to store datetime values. Not numeric or string types!

######Date
Dates are granular to the second. These always include the time of day. There is no "day" data type which stores calendar dates with no time in Oracle Database.
You can specify date values with the keyword date, followed by text in the format YYYY-MM-DD. 
For example the following is the date 14 Feb 2018:
date'2018-02-14'
This is a date with a time of midnight. If you need to state the time of day too, you need to use to_date. 

This takes the text of your date and a format mask. For example, this returns the datetime 23 July 2018 9:00 AM:
--> to_date ( '2018-07-23 09:00 AM', 'YYYY-MM-DD HH:MI AM' )

When you store dates, the database converts them to an internal format. The client controls the display format.

######Timestamp
If you need greater precision than dates, use timestamps.
These can include up to nine digits of fractional seconds. 
The precision states how many fractional seconds the column stores. By default you get six digits (microseconds).
You can specify timestamp values like dates. Either use the timestamp keyword or to_timestamp with a format mask:
 --> timestamp '2018-02-14 09:00:00.123'
 --> to_timestamp ( '2018-07-23 09:00:00.123 AM', 'YYYY-MM-DD HH:MI:SS.FF AM' )
 
Timestamps have another advantage over dates. You can store time zone information in them. You can't store time zone details in a date.
A timestamp with time zone column stores values passed as-is. When you query a timestamp with time zone, the database returns the value you stored.
The database converts values in local time zones to its time zone. When you fetch these columns, the database returns it in the time zone of the session.

######Time Intervals
You can store time durations with intervals. 

--> Oracle Database has two interval types: year to month and day to second.

You can add or subtract intervals from dates, timestamps or equivalent intervals. But the intervals are incompatible! You can't combine a day to second interval with a year to month one. This is because the number of days varies between months and years.
```sql
The following creates a table with the various datetime data types:
create table datetime_data (
  date_col                      date,
  timestamp_with_3_frac_sec_col timestamp(3),
  timestamp_with_tz             timestamp with time zone,
  timestamp_with_local_tz       timestamp with local time zone,
  year_to_month_col             interval year to month,
  day_to_second_col             interval day to second
);

select column_name, data_type, data_length, data_precision, data_scale
from   user_tab_columns
where  table_name = 'DATETIME_DATA';
```


##Binary Data Types
You use binary data to store in its original format. These are usually other files, such as graphics, sound, video or Word documents. 
There are two key binary types: raw and blob.
######Raw
Like with character data, raw is for smaller items. You specify the maximum length of data for each column. It has a maximum limit of 2,000 bytes up to 11.2 and 32,767 from 12.1.
######Blob
Blob stands for binary large object. As with clob, the maximum size you can store is (4 gigabytes - 1) * (database block size).
```sql
The following creates a table with binary data type columns:
create table binary_data (
  raw_col  raw(1000),
  blob_col blob
);

select column_name, data_type, data_length, data_precision, data_scale
from   user_tab_columns
where  table_name = 'BINARY_DATA';
```

##Adding Columns to Existing Tables
You add columns to an existing table with alter table. You can add as many as you want (up to the 1,000 column table limit):
```sql
The following adds two columns to the table this_table_has_three_columns. One timestamp and one blob:
alter table this_table_has_three_columns add (
  this_is_a_timestamp_column    timestamp, 
  this_is_a_binary_large_object blob
);

select column_name, data_type, data_length, data_precision, data_scale
from   user_tab_columns
where  table_name = 'THIS_TABLE_HAS_THREE_COLUMNS';
```

##Removing Columns from a Table
You can also remove columns from a table. To get rid of a column from a table, alter the table again, this time with the drop clause.

```sql
The following removes the columns you added to this_table_has_three_columns in the previous step:
alter table this_table_has_three_columns drop (
  this_is_a_timestamp_column, 
  this_is_a_binary_large_object
);

select column_name, data_type, data_length, data_precision, data_scale
from   user_tab_columns
where  table_name = 'THIS_TABLE_HAS_THREE_COLUMNS';
Note this is a one-way operation! After you drop a column there is no "undrop" command. If you want to get the column back, you have to restore it from a backup.
Dropping columns is an expensive operation. It can take a long time to complete on large tables. So always triple, quadruple check before running this!
```

##Other Data Types
Oracle Database includes other, specialized data types. These include XMLtype for XML documents. And spatial types to store location details.
For more details on these, read the data type documentation.

DATA TYPE:

##Oracle Database has the following built-in numeric data types:
number
float
binary_float
binary_double
It also supports the following ANSI data types, which map to the Oracle data type in italics:
numeric number
decimal number
integer number(p, 0)
int number(p, 0)
smallint number(p, 0)
double precision float(126)
real float(63)
 
The most common numeric data type is number. When you define this you can provide a precision and scale. The precision is the maximum number of significant digits you can store. This can range from 1 to 38. The scale defines the number of digits to the left or right of the decimal point to the least significant digit. It can range from -84 to 127.
Here are some examples of possible values:
Data type
Integer range
Fractional digit range
number(1,0)
+/- 0-9
No fractional digits
number(2,2)
0
0.00 - 0.99
number(2, -1)
0, +/- 10 - 990
No fractional digits

You get an error when trying to insert values exceeding the precision. But Oracle Database rounds values exceeding the scale. So if you try and insert 10 into a number(1,0) you'll get an error, because this requires two significant digits. But the value 0.999 only exceeds the scale of a number(1, 0). So the database inserts this, rounding it to 1.
It is good practice to specify a precision and scale. This ensures you can only store appropriate values. If you don't, provide either, they default to the maximum values. 
 
######Oracle Database supports the following character data types:
--> char
--> Varchar2 –You must specify a maximum length when creating varchar2 columns. The upper limit for this is 4,000 bytes in Oracle Database 11.2 and earlier. From 12.1, you can increase this up to 32,767 bytes.
--> nchar
--> nvarchar2
--> Clob –CLOB stands for Character Large OBject. You can use this to store text up to (2^32 - 1 bytes) * (database block size). The default block size in Oracle Database is 8k (8 * 2^10). Which gives a maximum size of 2^45 - 1 bytes.
--> Blob –used to store binary like images,pdf,word document
--> RAW –Yes. You can use raw to store binary data up to 2,000 bytes long. When you define a raw, you must specify its maximum size in bytes.
 Oracle Database 12c, the maximum size of a raw is 32,767 bytes if you set the MAX_STRING_SIZE parameter to EXTENDED
 
You use character data types to store free-form text, numbers and symbols. For example, names, descriptions and notes. 
When choosing a character data type, you need to know the maximum length of strings you plan to store in it. A varchar2 can store text up to 4,000 bytes long*. 
If you want to store strings larger than this, you need to use a clob. 
When you define varchar2 columns you must specify a length. This sets the largest string you can store in it.
```sql
You can also qualify this with byte or char. If you exclude this, it uses defaults to the value of the NLS_LENGTH_SEMANTICS parameter. For example:
create table t (
  c1 varchar2 (10),        /*10 characters or bytes, depending on  
                             NLS_LENGTH_SEMANTICS*/ 
  c2 varchar2 (255 char),  /*Strings up to 255 characters long*/
  c3 varchar2 (1000 byte), /*Strings up to 1,000 bytes long*/
); 
 ```
The difference between byte and char depends on the values. Most characters are a single byte. But they can be up to four bytes long, depending on the character set. A varchar2(1 char) can always store one character. But a varchar2(1 byte) only stores one byte, so is too small to store multi-byte values such as â, é and other accented characters (in UTF-8).
* In Oracle Database 12c Release 1 and later versions you can increase this to 32,767 bytes. But you have to set the database parameter MAX_STRING_SIZE to EXTENDED.
 ```sql
When defining a varchar2 column, you must specify its upper limit. You can do this in either bytes or characters. To control which, specify either char or byte after the limit, like so:
create table t (
  varchar_char_limit varchar2(100 char),
  varchar_byte_limit varchar2(100 byte)
);
```
The difference between the two comes when you use multibyte characters. Depending on your character set, accented characters such as é, á, etc. may use two bytes. If you specify the limit in characters, then you can store up to that many symbols or letters. But with a byte limit, you may hit the limit with less than 100 characters.
Whatever you do, the upper limit of 4,000 is in bytes. Not characters. If you're on 12c and want to have bigger varchar2 columns, you need to set the max_string_size parameter to extended. This increases the greatest size to 32,767 bytes. To store text larger than this, you need to use a clob.
 
 
##cTIME ZONE

To store dates and times with time zone information, use one of the following data types:
timestamp with time zone
timestamp with local time zone
For an example of how these work, check out this LiveSQL script. 
 
Datetime data types store when something happened or is planned to happen. Oracle Database supports the following datetime types:
date
timestamp
timestamp with time zone
timestamp with local time zone

The date data type only stores dates and times down to a granularity of one second. To store time zone details, you need to use either a:
timestamp with time zone
timestamp with local time zone
You store non-local time zones with an explicit time zone.
When you save a local time zone, Oracle Database normalizes it to the database's time zone. When you fetch these values, it converts them to your session's time zone. A timestamp with local time zone will always give the time in your session's time zone. 
You can check the current values for the database and your session with the dbtimezone and sessiontimezone functions:
select dbtimezone, sessiontimezone from dual;
```sql
DBTIMEZONE  SESSIONTIMEZONE  
-07:00      00:00 
This shows the database and client are in different time zones. 
Here's an example to show the difference between local and non-local time zones. Let's create a table with a column of each type and store 1 Jan 2017 00:00 with time zone +10 hours in each:
create table t (
  non_local_ts timestamp with time zone,
  local_ts     timestamp with local time zone
);

insert into t values (
  timestamp'2017-01-01 00:00:00 +10:00',
  timestamp'2017-01-01 00:00:00 +10:00'
);

select * from t;

NON_LOCAL_TS                        LOCAL_TS                        
01-JAN-2017 00.00.00.000000000 +10  31-DEC-2016 14.00.00.000000000
The column non_local_ts preserves the exact value you store in it. But the database normalizes the value before placing it in local_ts. To do this it subtracts the difference between the offset of the inserted value and the DB time zone. This is 17 hours (+10:00 to -07:00). So it stores 31 Dec 2016 07:00.
The session is in London time (+00:00). This is seven hours ahead of the database time (-07:00). So when you fetch the date, Oracle Database adds the difference to the stored value to give a datetime of 31 Dec 2016 14:00.
```
