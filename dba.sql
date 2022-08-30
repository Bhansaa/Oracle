               ***********************************************
                          DBA Handling queries
               ***********************************************

------> CHECK_USER_ROLE

SELECT grantee, listagg(granted_role, ', ') within group (order by granted_role) as roles
FROM DBA_ROLE_PRIVS
where grantee in
( select grantee
from DBA_ROLE_PRIVS
where granted_role = 'WMS_USERS')
and grantee in
( select username
from dba_users
where user_id > 100)
group by grantee;
