SELECT
--**********************************************************************************************************************************************************
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
-- para a nike os dados est�o na filial WMWHSE10
-- quando migrarmos para produ��o ser� necess�rio mudar para WMWHSE9
-- conforme orienta��o do Humberto - 21/12/2015
      cast(13 as int)                                     CD_CIA,
      OD.ORDERKEY                                         NR_PEDIDO_WMS, 
      O.WHSEID                                            CD_ARMAZEM,
      SUM(O.TOTALQTY)                                     NR_VOLUME,
      (SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(OSH.ADDDATE), 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
          AT time zone 'America/Sao_Paulo') AS DATE) 
          FROM WMWHSE10.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY AND OSH.STATUS>=51) DT_INICIO_PICKING,
      SUM(OD.QTYPICKED)                                   NR_VOLUME_FINALIZADOS,
      SUM(OD.SHIPPEDQTY)                                  NR_VOLUME_CONFERIDOS,
      (SELECT OSH.STATUS FROM WMWHSE10.ORDERSTATUSHISTORY OSH 
       WHERE OSH.ORDERKEY=OD.ORDERKEY 
       AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) 
            FROM WMWHSE10.ORDERSTATUSHISTORY OSH2
            WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
            AND ROWNUM=1)                                 CD_ULTIMA_OCORRENCIA,
      (SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MIN(OSH.ADDDATE), 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
          AT time zone 'America/Sao_Paulo') AS DATE) 
          FROM WMWHSE10.ORDERSTATUSHISTORY OSH 
            WHERE OSH.ORDERKEY=OD.ORDERKEY)               DT_ULT_ATUALIZACAO,
          O.EXTERNORDERKEY                                CD_EXTERNO_ORDER_KEY,
          O.CARRIERCODE                                   CD_TRANSPORTADORA,
      (SELECT OSH.SERIALKEY 
        FROM WMWHSE10.ORDERSTATUSHISTORY OSH 
          WHERE OSH.ORDERKEY=OD.ORDERKEY 
          AND OSH.ADDDATE=(SELECT MAX(OSH2.ADDDATE) 
            FROM WMWHSE10.ORDERSTATUSHISTORY OSH2 
              WHERE OSH2.ORDERKEY=OSH.ORDERKEY)
              AND ROWNUM=1)                               CD_ULTIMO_TRACKING,
      (select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cd.ADDDATE, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
          AT time zone 'America/Sao_Paulo') AS DATE) 
            from WMWHSE10.CAGEIDDETAIL cd
              where cd.ORDERID=OD.ORDERKEY 
              and ROWNUM=1)                               DT_INCLUSAO_VL_CARGA,
      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(O.ACTUALSHIPDATE, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
          AT time zone 'America/Sao_Paulo') AS DATE)      DT_SAIDA_CAMINHAO, 
      (select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cg.CLOSEDATE, 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
          AT time zone 'America/Sao_Paulo') AS DATE) 
            from WMWHSE10.CAGEID cg, WMWHSE10.CAGEIDDETAIL cd
              where cd.ORDERID=OD.ORDERKEY 
              and ROWNUM=1 and cg.cageid=cd.CAGEID)       DT_FECHA_GAIOLA,
      TO_CHAR(cd.cageid)                                  ID_GAIOLA

FROM WMWHSE10.ORDERDETAIL OD

left join WMWHSE10.CAGEIDDETAIL cd
on cd.ORDERID=OD.ORDERKEY,
     
     WMWHSE10.ORDERS O

WHERE O.ORDERKEY=OD.ORDERKEY

GROUP BY OD.ORDERKEY, 
          O.EXTERNORDERKEY, 
          O.CARRIERCODE, 
          O.WHSEID, 
          O.ACTUALSHIPDATE, 
         cd.cageid