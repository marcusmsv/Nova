SELECT
--  DISTINCT
    znsls400.t$ncia$c                                  CIA,
    znsls400.t$uneg$c                                  UNID_NEGOCIO,
    znsls400.t$pecl$c                                  PEDIDO,      
    znsls400.t$sqpd$c                                  SEQ_PEDIDO,
    znsls402.t$sequ$c                                  SEQ_PAGAMENTO,
    znsls402.t$cccd$c                                  NUM_BANDEIRA,
    nvl(zncmg009.t$desc$c, ' ')                        DSC_BANDEIRA,
    CASE WHEN Trim(znsls402.t$idad$c) = '0'
           THEN NULL
         ELSE   znsls402.t$idad$c
    END                                                ID_ADQUIRENTE,
    tccom100.t$nama                                    DSC_ADQUIRENTE,
    tccom100.t$bpid                                    PARCEIRO_NEGOCIO,
    znsls402.t$idmp$c                                  NUM_MEIO_PAGTO,  
    zncmg007.t$desc$c                                  DSC_MEIO_PAGTO, 
    znsls400.t$nomf$c                                  NOME_CLIENTE, 
    znsls400.t$fovn$c                                  CPF_CLIENTE, 
    znsls412.t$ttyp$c                                  TIPO_TRANSACAO,
    znsls412.t$ninv$c                                  DOC_TRANSACAO,
    ROUND(znsls492.t$trbd$c, 4)                        TAXA_CARTAO,
    znsls402.t$vlmr$c                                  VALOR_MEIO_PGTO,
    CASE WHEN znsls492.t$trbd$c IS NULL
           THEN NULL
         ELSE ROUND(znsls492.t$vltx$c, 2)
    END                                                VALOR_TAXA_CARTAO,
    CASE WHEN tfgld018.t$dcdt < TO_DATE('01/01/1990','DD/MM/YYYY') 
           THEN NULL
         ELSE tfgld018.t$dcdt 
    END                                                DATA_DOC,
    CASE WHEN znsls400.t$sige$c = 1
           THEN 'Sim'
         ELSE   'Não'
    END                                                PEDIDO_SIGE,
    CASE WHEN znsls400.t$migr$c = 1
           THEN 'Sim'
         ELSE   'Não'
    END                                                MIGRADO,
    CASE WHEN znsls409.t$dved$c = 1
           THEN 'Sim'
         ELSE   'Não'
    END                                                DEVOLVIDO,
    CASE WHEN znsls409.t$lbrd$c = 1
           THEN 'Sim'
         ELSE   'Não'
    END                                                FORCADO,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)     DATA_EMISSAO,
    znsls400.t$idpo$c                                  PONTO_ORIGEM

FROM      baandb.tznsls400301 znsls400

LEFT JOIN baandb.tznsls402301 znsls402 
       ON znsls402.t$ncia$c = znsls400.t$ncia$c
      AND znsls402.t$uneg$c = znsls400.t$uneg$c
      AND znsls402.t$pecl$c = znsls400.t$pecl$c
      AND znsls402.t$sqpd$c = znsls400.t$sqpd$c

LEFT JOIN baandb.tznsls412301 znsls412 
       ON znsls412.t$ncia$c = znsls402.t$ncia$c
      AND znsls412.t$uneg$c = znsls402.t$uneg$c
      AND znsls412.t$pecl$c = znsls402.t$pecl$c
      AND znsls412.t$sqpd$c = znsls402.t$sqpd$c
      AND znsls412.t$sequ$c = znsls402.t$sequ$c
       
LEFT JOIN baandb.ttfgld018301 tfgld018
       ON tfgld018.t$ttyp = znsls412.t$ttyp$c
      AND tfgld018.t$docn = znsls412.t$ninv$c

LEFT JOIN baandb.tzncmg007301 zncmg007 
       ON zncmg007.t$mpgs$c = znsls402.t$idmp$c        -- buscar pelo codigo do site
       
LEFT JOIN BAANDB.TZNSLS492301 znsls492
       ON znsls492.t$ncia$c = znsls402.t$ncia$c
      AND znsls492.t$uneg$c = znsls402.t$uneg$c
      AND znsls492.t$pecl$c = znsls402.t$pecl$c
      AND znsls492.t$sqpd$c = znsls402.t$sqpd$c
      AND znsls492.t$idmp$c = znsls402.t$idmp$c
      AND znsls492.t$sequ$c = znsls402.t$sequ$c
       
LEFT JOIN baandb.tzncmg009301 zncmg009
       ON zncmg009.t$band$c = znsls402.t$cccd$c

LEFT JOIN baandb.tzncmg008301 zncmg008                 -- BP do banco
       ON zncmg008.t$adqs$c = znsls402.t$idad$c
      AND zncmg008.t$cias$c = znsls402.t$ncia$c
      
LEFT JOIN baandb.ttccom100301 tccom100
       ON tccom100.t$bpid = zncmg008.t$adqu$c
       
LEFT JOIN baandb.tznsls409301 znsls409
       ON znsls409.t$ncia$c = znsls400.t$ncia$c
      AND znsls409.t$uneg$c = znsls400.t$uneg$c
      AND znsls409.t$pecl$c = znsls400.t$pecl$c
      AND znsls409.t$sqpd$c = znsls400.t$sqpd$c

WHERE NVL(tfgld018.t$dcdt, :DataDocDe)
      Between :DataDocDe 
          And :DataDocAte
  AND (          (:ValData = 0) 
        OR (   ( (:ValData = 1) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
                                              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                                AT time zone 'America/Sao_Paulo') AS DATE)) = :DtEmissaoDe ) )
            OR ( (:ValData = 2) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
                                              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                                AT time zone 'America/Sao_Paulo') AS DATE)) = :DtEmissaoAte ) )
            OR ( (:ValData = 3) AND ( Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c, 
                                              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                                                AT time zone 'America/Sao_Paulo') AS DATE)) Between :DtEmissaoDe And :DtEmissaoAte ) ) 
           )
       )
  AND NVL(Trim(znsls412.t$ttyp$c), '000') in (:Transacao)
  AND NVL(znsls412.t$ttyp$c,' ') NOT IN ('LPJ', 'FAT', 'RWC', 'RWA')