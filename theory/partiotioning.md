# Partiotioning

1) table >= 2GB possobile for partiotioning
2) Maintaning Rolling Data(historical data)--only current data is usable and other is read ONLY
3) Index partition ---avoid rebuiding entire index
2) partition segntment shows full table scan but only for that partiotioning
3) delte billion of rows in hugw table is take major amount of TIME
	1) option is to use partition and drop that partition--that will be much faster or instannt
	2) 
4) Data managebiltity
5) parformance
6) save space
7) faster backup and restore
8) low storage usage
7) if table not partition then if some natural cause all application is down ,but if partition than data is avaible for particular.


## When to Partition ?
• Table: Size bigger than 2 GB
Maintaining rolling data (historical data)
• Divide data across nodes
• Index: Avoid Rebuilding the entire Index when data
removed
• Perform Maintenance on part of the data without
invalidating the entire index.
further in our next tutorial. As we move ahead,
• Reduce lets just quickly recall the advantages one


#### LIST PARTIONING



Partition Key
• Region
• It helps uniquely identify how each row should be
mapped to which partition

USE ONLY when we have predefined value for COLUMNS

if not it will give belwo error

Error: ORA-14400: inserted partition key does
not map to any partition
• Insert into transaction_demoi values
(1,'credit',300,trunc(sysdate),'IND');
• Error: ORA-14400

------LOCAL VS GLBAL------

IF INDEX KEY is same/subset as PARTIONINIGN KEY ------LOCAL INDEX
index can be dropped with partition

IF INDEX columns are different than PARK------GLOBAL INDEX
	CHALLENGE --> IF a partion is dropped than global index will be unsable


#### RANGE PARTITIONING

