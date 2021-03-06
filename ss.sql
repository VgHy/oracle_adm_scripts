/*
Lista Todas as sessões
*/
@set

ACCEPT VAR_USER PROMPT 'INFORME O USUARIO (ORACLE): '
ACCEPT VAR_OS PROMPT   'INFORME O USUARIO (OS)    : '
ACCEPT VAR_PRGM PROMPT 'INFORME O PROGRAMA        : '
ACCEPT VAR_MCH PROMPT  'INFORME A MACHINE         : '
ACCEPT VAR_SID PROMPT  'INFORME O SID             : '

SELECT SID, USERNAME,
    STATUS,
    OSUSER,
    PROGRAM,
    TO_CHAR(LOGON_TIME, 'DD/MM HH24:MI') "LOGIN",
    TO_CHAR(SYSDATE - (LAST_CALL_ET) / 86400,'DD/MM HH24:MI') ACESSO,
    LPAD(TRIM(TO_CHAR(FLOOR(((SYSDATE-LOGON_TIME)*86400)/(3600)), 900)) ||':'|| TRIM(TO_CHAR(FLOOR((((SYSDATE-LOGON_TIME)*86400) - (FLOOR(((SYSDATE-LOGON_TIME)*86400)/(3600))*3600))/60), 900)) ||':'||TRIM(TO_CHAR(MOD((((SYSDATE-LOGON_TIME)*86400) - (FLOOR(((SYSDATE-LOGON_TIME)*86400)/(3600))*3600)),60), 900)), 10, ' ') "TEMPO",
    LPAD(TRIM(TO_CHAR(FLOOR(LAST_CALL_ET/(3600)),900)||':'||TRIM(TO_CHAR(FLOOR((LAST_CALL_ET - (FLOOR(LAST_CALL_ET/(3600))*3600))/60),900))||':'||TRIM(TO_CHAR(MOD((LAST_CALL_ET - (FLOOR(LAST_CALL_ET/(3600))*3600)),60),900))), 10, ' ') " IDLE TIME",
    MACHINE,
    TERMINAL,
    CASE
        WHEN (TRUNC((&_O_RELEASE/100000000)) >= 12) THEN
            'ALTER SYSTEM KILL SESSION ' || CHR(39) || SID ||','||SERIAL# ||', @'||INST_ID|| CHR(39) || ' IMMEDIATE ;'
        ELSE
            '[node ' || INST_ID || '] ALTER SYSTEM DISCONNECT SESSION ' || CHR(39) || SID ||','||SERIAL# || CHR(39) || ' IMMEDIATE ;'
    END "MATAR A SESSÃO",
    SCHEMANAME,
    sql_id
FROM  GV$SESSION
WHERE UPPER(USERNAME)           LIKE UPPER('%&VAR_USER%')
AND   UPPER(NVL(OSUSER, '%'))   LIKE UPPER('%&VAR_OS%')
AND   UPPER(NVL(PROGRAM, '%'))  LIKE UPPER('%&VAR_PRGM%')
AND   UPPER(NVL(MACHINE, '%'))  LIKE UPPER('%&VAR_MCH%')
AND   SID like '%&VAR_SID%'
ORDER BY STATUS, SYSDATE-LOGON_TIME, PROGRAM DESC;

select count(1) qtd, username, status from gv$session where username is not null group by username, status;

CLEAR COL
UNDEF VAR_USER VAR_OS VAR_PRGM VAR_MCH VAR_SID