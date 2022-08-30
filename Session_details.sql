                                    **************************************************
                                             Query to get session details: 
                                    **************************************************

 

select 
   b.username, 
   a.session_id, 
   a.LOCKED_MODE, 
   b.STATUS, 
   c.owner, 
   b.blocking_session, 
   b.SECONDS_IN_WAIT 
from 
   v$locked_object a , 
   gv$session b, 
   dba_objects c 
where 
   b.sid = a.session_id 
and 
   a.object_id = c.object_id; 
