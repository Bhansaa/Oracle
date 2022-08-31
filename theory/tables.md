# The table types Oracle Database supports includes:
  --> Heap organized
  --> Index organized
  --> Externally organized
  --> Temporary 
  
The table types include:
-->Heap tables
These are the default table type. They are good for general-purpose data access.
Most of the tables you create will be heaps. 

-->Index Organized Table (IOT)
An IOT stores data physically ordered according to the primary key. 
These are most suitable when you want to ensure fast data access by this key. 

-->External Table
You use external tables to read non-database files using SQL.
 These are ideal if you need to load comma separate value (CSV) files into your database.
 
-->Temporary Table 
These store data private to your session.
 These are useful if you have processes which save working data that you need to remove when its complete.
 
Table Clusters

This is a data structure that can hold many tables. 
Rows from different tables with the same cluster key go in the same place.
 This can make accessing related rows from clustered tables much faster than non-clustered.
 This is because non-clustered tables will always store rows in different locations. 

table types can you use to place some physical order on your data?

If you want rows with similar properties to be physically stored near to each-other, you should use one of the following data structures:
Index organized tables
Table clusters
Partitioning

For example of how to use these, go to this LiveSQL script. 
 
Physically storing rows with similar properties near each other can make data access faster.
 For example, say you arrange your toys by color. This makes it easier to find all the red toys. 
The data structures you can use to impose some order on your data include:

--> Index Organized Table 
Here the data are stored sorted according to the primary key. For example, if the primary key column stores the values 1, 2, 3, etc. the row with the value 2 is guaranteed to be "between" those with 1 and 3. 
Partitioned Table
Partitioning effectively splits your table into smaller tables. You can partition heap tables and IOTs.
 Like a standard heap table, Oracle Database adds rows to a partitioned heap wherever there is space within the partition.
 But rows in a partitioned IOT must go in the correct place within the partition defined by the primary key. 
You must choose a partitioning strategy to use this.
 This defines how Oracle Database assigns rows to partitions.
 The methods available are hash, range and list. For more details on this, read the partitioning concepts guide. 

Note: Partitioning is an extra cost option! Ensure you are licensed to use it before you start doing so. 

--> Table Clusters
This enables you physically store rows from many tables in the same place. 
This can make it faster to get related rows from different tables. 
For example, say you have two tables, one for teddies and one for bricks. 
You often want to find all the bricks and teddies of the same colour.
 By placing these in a cluster, grouped by colour this reduces the work you do to find all the red items.

--> CREATE TABLE

To create a table, you need to specify its:
Name
Columns
The data type of each column
If you omit any of these the statement will fail. 

By default you get a heap-organized table. If you want to create a table with different properties, 
you need to specify this.
 For example, to create an index-organized table, specify a primary key and add the organization index clause:
 
```sql 
SYNTAX:

create table bricks (
  color  varchar2(30) primary key,
  weight number
) organization index;
Or to partition it, add a partition by clause:
create table bricks (
  color  varchar2(30),
  weight number
) partition by list ( color ) (
  partition p_red values ( 'red' ),
  partition p_green values ( 'green' ),
  partition p_blue values ( 'blue' )
);
```
