-- 06-jan-2014, Fabio Ferreira, Corre��o de convers�o de timezone
--								Cria��o do campo Efetiva
--****************************************************************************************************************************************************************
SELECT  tcmcs008.t$rtyp COD_COTACAO,
        tcmcs008.t$ccur CD_MOEDA,
        tcmcs008.t$rate VL_COTACAO,
        CAST((FROM_TZ(CAST(TO_CHAR(tcmcs008.t$stdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
          AT time zone sessiontimezone) AS DATE) DT_COTACAO,
        CAST((FROM_TZ(CAST(TO_CHAR(tcmcs008.t$apdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 
          AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,
        CASE WHEN (select MAX(b.t$stdt) From ttcmcs008201 b
                  where b.t$rtyp=tcmcs008.t$rtyp
                  and   b.t$ccur=tcmcs008.t$ccur)=tcmcs008.t$stdt THEN 1 ELSE 2 END IN_EFETIVA
FROM    ttcmcs008201 tcmcs008
WHERE	tcmcs008.t$bcur='BRL'
AND		tcmcs008.t$rapr=1