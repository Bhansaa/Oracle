# Wildcards
When searching strings, you can find rows matching a pattern using LIKE. This has two wildcard characters:
 --> Underscore (_) matches exactly one character
 --> Percent (%) matching zero or more characters
You can place these either side of the characters you're searching for. So this finds all the rows that have a colour starting with b:
```sql
select * from toys
where  colour like 'b%';

And this all the rows with colours ending in n:

select * from toys
where  colour like '%n';

Underscore matches exactly one character. So the following finds all the rows with toy_names eleven characters long:
select * from toys
where  toy_name like '___________';
Percent is true even if it matches no characters. So the following tests to search for colours containing the letter "e" all return different results:

select * from toys
where  colour like '_e_';

select * from toys
where  colour like '%e%';

select * from toys
where  colour like '%_e_%';

This is because these searches work as follows:
_e_ => any colour with exactly one character either side of e (red)
%e% => any colour that contains e anywhere in the string (red, blue, green)
%_e_% => any colour with at least one character either side of e (red, green)
```
Searching for Wildcard Characters
You may want to find rows that contain either underscore or percent. 
For example, if you want to see all the rows that include underscore in the toy_name, you might try:

select * from toys
where  toy_name like '%_%';
But this returns all the rows!

This is because it sees underscore as the wildcard. So it looks for all rows that have at least one character in toy_name.
To avoid this, you can use escape characters. Place this character before the wildcard. Then state what it is in the escape clause after the condition. This can be any character. But usually you'll use symbols you're unlikely to search for. Such as backslash \ or hash #.
```sql
So both the following find Miss Smelly_bottom, the only toy_name that includes an underscore:
select * from toys
where  toy_name like '%\_%' escape '\';

select * from toys
where  toy_name like '%#_%' escape '#';
```
