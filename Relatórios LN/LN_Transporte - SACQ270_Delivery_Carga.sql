Select Q1.* From 
     ( SELECT 
         DISTINCT
         znsls400ret.t$idca$c         ID_CANAL,
         CASE WHEN ( SELECT  znfmd640.t$stat$c
                       FROM  baandb.tznfmd640301 znfmd640
                   WHERE  znfmd640.t$fili$c = znfmd630ret.t$fili$c
                        AND  znfmd640.t$etiq$c = znfmd630ret.t$etiq$c
                        AND  znfmd640.t$date$c = ( SELECT max(znfmd640.t$date$c) 
                                                     FROM baandb.tznfmd640301 znfmd640
                                                    WHERE znfmd640.t$fili$c = znfmd630ret.t$fili$c
                                                      AND znfmd640.t$etiq$c = znfmd630ret.t$etiq$c) AND ROWNUM=1 ) = 'F' 
                THEN 'FECHADO' 
           ELSE 'ABERTO' 
         END                          TP_ESTADO,  
         
         
         znsls401ret.t$cmot$c         ID_MOTIVO,
         znsls401ret.t$lmot$c         MOTI_NOME,
         znsls401ret.t$orno$c         ID_INSTANCIA,
         tccom130ori.t$fovn$l         CNPJ_TRANSP,
         tcmcs080ori.t$dsca           TRANSP_NOME,
         znfmd630ori.t$cono$c         TRANSP_CONTRATO,
         tccom130ret.t$fovn$l         CNPJ_TRANSP_COLETA,
         tcmcs080ret.t$dsca           TRANSP_NOME_COLETA,
         znfmd630ret.t$cono$c         TRANSP_CONTRATO_COLETA,
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400ret.t$dtin$c, 
          'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
            AT time zone sessiontimezone) AS DATE)
                                      DT_OCORR,
         
         CASE WHEN znfmd630ret.t$stat$c = 'F' 
                THEN 'FECHADO' 
              ELSE   'ABERTO' 
         END                          SITUACAO,
         
         ( SELECT  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd640.t$date$c, 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                        AT time zone sessiontimezone) AS DATE)
               FROM  baandb.tznfmd640301 znfmd640
              WHERE  znfmd640.t$fili$c = znfmd630ret.t$fili$c
                AND  znfmd640.t$etiq$c = znfmd630ret.t$etiq$c
                AND  znfmd640.t$date$c = ( SELECT max(znfmd640.t$date$c) 
                                             FROM baandb.tznfmd640301 znfmd640
                                           WHERE znfmd640.t$fili$c = znfmd630ret.t$fili$c
                                              AND znfmd640.t$etiq$c = znfmd630ret.t$etiq$c ) AND ROWNUM=1 ) 
                                      DT_SITUACAO,
     
         znsls401ret.t$pecl$c         PED_CLIENTE,
         znsls401ret.t$entr$c         ID_PEDIDO,
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940ori.t$date$l, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone sessiontimezone) AS DATE)
                                      DT_EMISSAO_NFS,
         cisli940ori.t$docn$l         ID_NF_ORIG,
         cisli940ori.t$seri$l         SERIE_ORIG,
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940ret.t$date$l, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone sessiontimezone) AS DATE)
                                      DT_EMISSAO_NFE,
         znfmd630ret.t$fili$c         FILI_NFE,
         cisli940ret.t$docn$l         NFE,
         cisli940ret.t$seri$l         SR_NFE,
         tccom130cli.t$fovn$l         CLIE_NFE,
         cisli940ret.t$stat$l         SIT_NFE, DESC_STAT,  
         cisli940ret.t$fire$l         NR,
         cisli940ret.t$stat$l         SIT_NR,
        
         CASE WHEN nvl( ( select max(a.t$list$c) 
                            from baandb.tznsls405301 a
                           where a.t$ncia$c=znsls401ret.t$ncia$c
                             and a.t$uneg$c=znsls401ret.t$uneg$c
                             and a.t$pecl$c=znsls401ret.t$pecl$c
                             and a.t$sqpd$c=znsls401ret.t$sqpd$c
                             and a.t$entr$c=znsls401ret.t$entr$c
                             and a.t$sequ$c=znsls401ret.t$sequ$c ),1 ) = 0 
                THEN 1 
              ELSE 2 
          END                         IN_FORCADO,
       
         znsls401gar.t$vlun$c         VL_GARANTIA,
         
         ( SELECT CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(MAX(znfmd640.t$date$c), 
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                      AT time zone sessiontimezone) AS DATE)
             FROM baandb.tznfmd640301 znfmd640
            WHERE znfmd640.t$fili$c = znfmd630ret.t$fili$c
              AND znfmd640.t$etiq$c = znfmd630ret.t$etiq$c
              AND znfmd640.t$date$c = ( SELECT max(znfmd640.t$date$c) 
                                          FROM baandb.tznfmd640301 znfmd640
                                         WHERE znfmd640.t$fili$c = znfmd630ret.t$fili$c
                                           AND znfmd640.t$etiq$c = znfmd630ret.t$etiq$c ) 
              AND ROWNUM = 1 )        ULT_PONTO_ENTREGA,
       
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630ret.t$udat$c, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone sessiontimezone) AS DATE)
                                      ULT_ALTERACAO,
         znsls401ret.t$cepe$c         CEP,
         znsls401ret.t$cide$c         MUNI_NOME,
         znsls401ret.t$ufen$c         MUNI_ESTADO,
         Trim(cisli941ret.t$item$l)   ID_ITEM,
         cisli941ret.t$desc$l         ITEM_NOME,
         cisli941ret.t$dqua$l         QTD_ITEM, 
         cisli940ret.t$amnt$l         VLR_TOT_NF,
         cisli941ret.t$iprt$l         VLR_TOT_ITEM,
         cisli941ret.t$fght$l         VLR_FRETE_ITEM,  
         
         
         znfmd630ret.t$ncar$c         CARGA,
         znfmd630ret.t$etiq$c         ETIQUETA,
         
         znsls401ret.t$ccat$c         CODE_LAUDO,
         znsls010.t$lcat$c            DESCR_LAUDO,
         znsls401ret.t$lcat$c         LAUDO_ETQ_WMS,
         znsls401ret.t$cass$c         CODE_ASSUNTO,
         znsls011.t$lass$c            DESCR_ASSUNTO,
         znsls401ret.t$lass$c         ASSUNTO_ETQ_WMS,
         znsls401ret.t$cmot$c         CODE_MOTIVO,
         znsls012.t$lmot$c            DESCR_MOTIVO,
         znsls401ret.t$lmot$c         MOTIVO_ETQ_WMS,
       
         znsls400ret.t$ncia$c         UNID_NEG,
         znfmd630ret.t$fili$c         FILIAL,
         CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znfmd630ret.t$date$c, 
           'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
             AT time zone sessiontimezone) AS DATE)
                                      DT_REGISTRO,
         znfmd001ret.t$dsca$c         NOME_FILIAL,
         znfmd001ret.t$fovn$c         CNPJ_FILIAL,
         ( select a.t$desc$c 
             from baandb.tznint002301 a
            where a.t$ncia$c = znsls400ret.t$ncia$c
              and a.t$uneg$c = znsls400ret.t$uneg$c ) 
                                      DESCR_UNID_NEG
        
       FROM      BAANDB.tcisli940301  cisli940ret 
       
       LEFT JOIN BAANDB. tznfmd630301  znfmd630ret
              ON znfmd630ret.t$fire$c = cisli940ret.t$fire$l 
			  
       LEFT JOIN BAANDB. tznfmd001301  znfmd001ret
              ON znfmd001ret.t$fili$c = znfmd630ret.t$fili$c
           
       LEFT JOIN BAANDB.tznfmd640301  znfmd640ret
              ON znfmd640ret.t$fili$c = znfmd630ret.t$fili$c 
             AND znfmd640ret.t$etiq$c = znfmd630ret.t$etiq$c
      
       LEFT JOIN BAANDB.ttccom130301  tccom130cli
              ON tccom130cli.t$cadr = cisli940ret.t$stoa$l  
       
       LEFT JOIN BAANDB.ttcmcs080301  tcmcs080ret
              ON tcmcs080ret.t$cfrw = CISLI940ret.T$CFRw$L
       
       LEFT JOIN BAANDB.ttccom130301  tccom130ret
              ON tccom130ret.t$cadr = tcmcs080ret.t$cadr$l,
                 BAANDB.tcisli940301  cisli940ori
        
       LEFT JOIN BAANDB.ttcmcs080301  tcmcs080ori
              ON tcmcs080ori.t$cfrw = cisli940ori.t$cfrw$l
       
       LEFT JOIN BAANDB.ttccom130301  tccom130ori
              ON tccom130ori.t$cadr = tcmcs080ori.t$cadr$l
       
       LEFT JOIN BAANDB.tznfmd630301  znfmd630ori
              ON znfmd630ori.t$fire$c = cisli940ori.t$fire$l,
       
                 BAANDB.tcisli245301  cisli245ret   
        
       LEFT JOIN BAANDB.tcisli941301  cisli941ret  
              ON cisli941ret.t$fire$l = cisli245ret.t$fire$l
             AND cisli941ret.t$line$l = cisli245ret.t$line$l,
           
                 BAANDB.tcisli245301  cisli245ori,
                 BAANDB.tznsls401301  znsls401ori
        
       LEFT JOIN BAANDB.tznsls401301  znsls401gar
              ON znsls401gar.t$ncia$c = znsls401ori.t$ncia$c
             AND znsls401gar.t$uneg$c = znsls401ori.t$uneg$c       
             AND znsls401gar.t$pecl$c = znsls401ori.t$pecl$c
             AND znsls401gar.t$sqpd$c = znsls401ori.t$sqpd$c
             AND znsls401gar.t$entr$c = znsls401ori.t$entr$c
             AND znsls401gar.t$sgar$c = znsls401ori.t$sequ$c, 
      
                 BAANDB.tznsls400301  znsls400ret,                  
                 BAANDB.ttdsls401301  tdsls401ret  
        
       LEFT JOIN BAANDB.tznsls401301  znsls401ret
              ON tdsls401ret.t$orno = znsls401ret.t$orno$c
             AND tdsls401ret.t$pono = znsls401ret.t$pono$c
      
       LEFT JOIN BAANDB.tznsls010301 znsls010 
              ON znsls010.t$ccat$c=znsls401ret.t$ccat$c
   
       LEFT JOIN BAANDB.tznsls011301 znsls011 
              ON znsls011.t$ccat$c=znsls401ret.t$ccat$c
             AND znsls011.t$cass$c=znsls401ret.t$cass$c
        
       LEFT JOIN BAANDB.tznsls012301 znsls012 
              ON znsls012.t$ccat$c=znsls401ret.t$ccat$c
             AND znsls012.t$cass$c=znsls401ret.t$cass$c
             AND znsls012.t$cmot$c=znsls401ret.t$cmot$c,
           
                ( SELECT d.t$cnst CODE_STAT, l.t$desc DESC_STAT
                   FROM BAANDB.tttadv401000 d, BAANDB.tttadv140000 l 
                  WHERE d.t$cpac='ci' 
                    AND d.t$cdom='sli.stat'
                    AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                                     (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                                      from baandb.tttadv401000 l1 
                                      where l1.t$cpac=d.t$cpac 
                                      AND l1.t$cdom=d.t$cdom)
                    AND l.t$clab=d.t$za_clab
                    AND l.t$clan='p'
                    AND l.t$cpac='ci'
                    AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                                    (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                                      from baandb.tttadv140000 l1 
                                      where l1.t$clab=l.t$clab 
                                      AND l1.t$clan=l.t$clan 
                                      AND l1.t$cpac=l.t$cpac) ) DSTAT
                         
     WHERE cisli940ret.t$fdty$l = 14
       AND cisli940ret.t$fire$l = cisli245ret.t$fire$l
       AND tdsls401ret.t$orno   = cisli245ret.t$slso
       AND tdsls401ret.t$pono   = cisli245ret.t$pono
       AND cisli245ori.t$fire$l = tdsls401ret.t$fire$l
       AND cisli245ori.t$line$l = tdsls401ret.t$line$l   
       AND cisli940ori.t$fire$l = cisli245ori.t$fire$l
       AND cisli940ori.t$stat$l = DSTAT.CODE_STAT
       AND znsls400ret.t$ncia$c = znsls401ret.t$ncia$c 
       AND znsls400ret.t$uneg$c = znsls401ret.t$UNEG$c 
       AND znsls400ret.t$pecl$c = znsls401ret.t$pecl$c 
       AND znsls400ret.t$sqpd$c = znsls401ret.t$sqpd$c 
       AND znsls401ori.t$orno$c = cisli245ori.t$slso
       AND znsls401ori.t$pono$c = cisli245ori.t$pono 
     
     ) Q1
   
--WHERE Q1.DT_SITUACAO BETWEEN :DataSituacaoDe AND :DataSituacaoAte
--  AND Q1.DT_REGISTRO BETWEEN :DataRegistroDe AND :DataRegistroAte
--  AND Q1.UNID_NEG IN (:UnidNegocio)
--  AND Q1.FILIAL IN (:Filial)
--  AND Q1.SITUACAO IN (:Situacao)
--  AND Q1.IN_FORCADO = :Forcado
  
  
-- Data da Situacao
-- Data do Registro
-- Unidade de Negocio
-- Filial
-- Situacao
-- Forcada    
  
  
  