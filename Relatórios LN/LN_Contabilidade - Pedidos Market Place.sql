SELECT DISTINCT
       CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 
         'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
           AT time zone 'America/Sao_Paulo') AS DATE) 
                               DATA_EMISSAO,

       CISLI940.T$FIRE$L       REF_FISCAL,
       CISLI940.T$DOCN$L       NF,
       CISLI940.T$SERI$L       SERIE_NF,
       CISLI940.T$FDTC$L       COD_TIPO_DOC_FISCAL,
       TCMCS966.T$DSCA$L       DESCR_TIPO_DOC_FISCAL,
       CISLI940.T$ITYP$L       TIPO_TRANSACAO,
       CISLI940.T$IDOC$L       NUM_DOCUMENTO,
       ZNSLS401.T$PECL$C       NUM_PEDIDO,
       ZNSLS401.T$SQPD$C       SEQ_PEDIDO,
       ZNSLS401.T$IDLO$C       COD_LOGISTA,
       CISLI940.T$BPID$L       ID_PARCEIRO,
       TCCOM130.T$FOVN$L       CPF_CNJ_CLIENTE,
       
       CISLI940.T$GAMT$L  VALOR_ITEM_NF,
       CISLI940.T$FGHT$L  VALOR_FRETE_NF,
       CISLI940.T$AMNT$L  VALOR_TOTAL_NF
	   
FROM       BAANDB.TCISLI940301 CISLI940

INNER JOIN BAANDB.TCISLI941301 CISLI941
        ON CISLI941.T$FIRE$L = CISLI940.T$FIRE$L
    
INNER JOIN BAANDB.TTCIBD001301 TCIBD001
        ON TCIBD001.T$ITEM = CISLI941.T$ITEM$L
        
INNER JOIN BAANDB.TZNISA002301 ZNISA002
        ON ZNISA002.T$NPCL$C = TCIBD001.T$NPCL$C
	   
INNER JOIN BAANDB.TZNISA001301 ZNISA001
        ON TRIM(ZNISA001.T$NPTP$C) = TRIM(ZNISA002.T$NPTP$C)
	   
INNER JOIN BAANDB.TTCCOM130301 TCCOM130
        ON TCCOM130.T$CADR  = CISLI940.T$ITOA$L
    
INNER JOIN BAANDB.TCISLI245301 CISLI245
        ON CISLI245.T$FIRE$L = CISLI941.T$FIRE$L
       AND CISLI245.T$LINE$L = CISLI941.T$LINE$L
    
INNER JOIN BAANDB.TZNSLS004301 ZNSLS004
        ON ZNSLS004.T$ORNO$C = CISLI245.T$SLSO
       AND ZNSLS004.T$PONO$C = CISLI245.T$PONO
    
 LEFT JOIN BAANDB.TZNSLS401301 ZNSLS401
        ON ZNSLS401.T$NCIA$C = ZNSLS004.T$NCIA$C
       AND ZNSLS401.T$UNEG$C = ZNSLS004.T$UNEG$C
       AND ZNSLS401.T$PECL$C = ZNSLS004.T$PECL$C
       AND ZNSLS401.T$SQPD$C = ZNSLS004.T$SQPD$C
       AND ZNSLS401.T$ENTR$C = ZNSLS004.T$ENTR$C
       AND ZNSLS401.T$SEQU$C = ZNSLS004.T$SEQU$C

INNER JOIN BAANDB.TTCMCS966301 TCMCS966
        ON TCMCS966.T$FDTC$L = CISLI940.T$FDTC$L

WHERE ZNISA001.T$EMNF$C = 2
  AND ZNISA001.T$BPTI$C = 5
  AND ZNISA001.T$SIIT$C = 1
--  AND ZNISA001.T$NFED$C = 1   --Homologação
  AND ZNISA001.T$NFED$C = 2 --Produção
  
  AND CISLI940.T$STAT$L IN (5,6)
  
  AND TRUNC(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(CISLI940.T$DATE$L, 
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                AT time zone 'America/Sao_Paulo') AS DATE))
      BETWEEN :DataEmissaoDe
          AND :DataEmissaoAte

  AND ((:NotaFiscalTodos = 1) or (CISLI940.T$DOCN$L in (:NotaFiscal) and (:NotaFiscalTodos = 0)))
  AND ((:PedidoTodos = 1) or (ZNSLS401.T$PECL$C in (:Pedido) and (:PedidoTodos = 0)))