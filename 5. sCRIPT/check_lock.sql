-- Tổng quan Blocking Session
SELECT
    'alter system kill session ''' || SID || ',' || s.serial # || ',@'||inst_id||''';' as "Kill Scripts" ,sid,username,serial#,process,NVL (sql_id, 0),
    blocking_session,
    wait_class,
    event,
    seconds_in_wait
FROM
    gv$session s
WHERE
    blocking_session_status = 'VALID'
    OR sid IN (
        SELECT
            blocking_session
        FROM
            gv $ session
        WHERE
            blocking_session_status = 'VALID'
    );

-- Check Blocking Session TreeSELECT level,
LPAD(' ', (level -1) * 2, ' ') || NVL(s.username, '(oracle)') AS username,
s.osuser,
s.sid,
s.serial #,
s.lockwait,
s.status,
s.module,
s.machine,
s.program,
TO_CHAR(s.logon_Time, 'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM
    v$session s
WHERE
    level > 1
    OR EXISTS (
        SELECT
            1
        FROM
            v $ session
        WHERE
            blocking_session = s.sid
    ) CONNECT BY PRIOR s.sid = s.blocking_session START WITH s.blocking_session IS NULL;