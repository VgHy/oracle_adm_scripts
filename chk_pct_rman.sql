set pages 900 lines 900
SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,
ROUND (SOFAR/TOTALWORK*100, 2) "% COMPLETE"
FROM V$SESSION_LONGOPS
WHERE OPNAME LIKE 'RMAN%' AND OPNAME NOT LIKE '%aggregate%'
AND TOTALWORK! = 0 AND SOFAR <> TOTALWORK;