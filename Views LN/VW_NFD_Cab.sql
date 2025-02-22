﻿SELECT
    1                                                     CD_CIA,
    case when (SELECT tcemm030.t$euca 
      FROM baandb.ttcemm124201 tcemm124, 
           baandb.ttcemm030201 tcemm030
      WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
      AND tcemm030.t$eunt=tcemm124.t$grid
      AND tcemm124.t$loco=201
      AND rownum=1) = ' ' then
    (SELECT substr(tcemm124.t$grid,-2,2) 
      FROM baandb.ttcemm124201 tcemm124
      WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
      AND tcemm124.t$loco=201
      AND rownum=1)else
    (SELECT tcemm030.t$euca 
      FROM baandb.ttcemm124201 tcemm124, 
           baandb.ttcemm030201 tcemm030
      WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
      AND tcemm030.t$eunt=tcemm124.t$grid
      AND tcemm124.t$loco=201
      AND rownum=1) end                                     CD_FILIAL,
    cisli940.t$docn$l                                       NR_NF,
    cisli940.t$seri$l                                       NR_SERIE_NF,
    cisli940.t$ccfo$l                                       CD_NATUREZA_OPERACAO,
    cisli940.t$opor$l                                       SQ_NATUREZA_OPERACAO,
    cisli940.t$fdty$l                                       CD_TIPO_NF,
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)          DT_EMISSAO_NF,

    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$date$l, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)          HR_EMISSAO_NF,

    cisli940.t$itbp$l                                       CD_CLIENTE_FATURA,
    cisli940.t$stbp$l                                       CD_CLIENTE_ENTREGA,

    (SELECT cisli942.t$amnt$l 
      FROM baandb.tcisli942201 cisli942
      WHERE cisli942.t$fire$l=cisli940.t$fire$l
      AND   cisli942.t$brty$l=1)                            VL_ICMS,

    (SELECT cisli942.t$amnt$l 
      FROM baandb.tcisli942201 cisli942
      WHERE cisli942.t$fire$l=cisli940.t$fire$l
      AND   cisli942.t$brty$l=2)                            VL_ICMS_ST,
    
    (SELECT cisli942.t$amnt$l 
      FROM baandb.tcisli942201 cisli942
      WHERE cisli942.t$fire$l=cisli940.t$fire$l
      AND   cisli942.t$brty$l=3)                            VL_IPI,

    cisli940.t$gamt$l                                       VL_PRODUTO,
    cisli940.t$fght$l                                       VL_FRETE,
    cisli940.t$insr$l                                       VL_SEGURO,
    cisli940.t$gexp$l                                       VL_DESPESA,

    (SELECT cisli942.t$amnt$l 
      FROM baandb.tcisli942201 cisli942
      WHERE cisli942.t$fire$l=cisli940.t$fire$l
      AND   cisli942.t$brty$l=16)                           VL_IMPOSTO_IMPORTACAO,

    (SELECT sum(cisli941.t$ldam$l) 
      FROM baandb.tcisli941201 cisli941
      WHERE cisli941.t$fire$l=cisli940.t$fire$l)            VL_DESCONTO,

    cisli940.t$amnt$l VL_TOTAL_NF,

    CAST((FROM_TZ(TO_TIMESTAMP(
      TO_CHAR(Greatest(cisli940.t$datg$l,
                       cisli940.t$date$l, 
                       cisli940.t$dats$l), 'DD-MON-YYYY HH24:MI:SS'), 
      'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)          DT_SITUACAO_NF,

    cisli940.t$stat$l                                       CD_SITUACAO_NF,
    cisli940.t$amfi$l                                       VL_DESPESA_FINANCEIRA,

    (SELECT cisli942.t$amnt$l 
      FROM baandb.tcisli942201 cisli942
      WHERE cisli942.t$fire$l=cisli940.t$fire$l
      AND   cisli942.t$brty$l=5)                            VL_PIS,

    (SELECT cisli942.t$amnt$l 
      FROM baandb.tcisli942201 cisli942
      WHERE cisli942.t$fire$l=cisli940.t$fire$l
      AND   cisli942.t$brty$l=6)                            VL_COFINS,

    Nvl((SELECT sum(cisli943.t$amnt$l) 
      from baandb.tcisli943201 cisli943
      WHERE  cisli943.t$fire$l=cisli940.t$fire$l
      AND    cisli943.t$brty$l=13),0)                       VL_CSLL,

    entr.t$vldi$c                                           VL_DESCONTO_INCONDICIONAL,
    cisli940.t$cchr$l                                       VL_DESPESA_ADUANEIRA,

    nvl((select sum(l.t$gexp$l) 
      from baandb.tcisli941201 l
      where l.t$fire$l = cisli940.t$fire$l
      and  (l.t$sour$l=2 or l.t$sour$l=8)),0)               VL_ADICIONAL_IMPORTACAO,

    nvl((select sum(li.t$amnt$l) 
      from baandb.tcisli943201 li, 
           baandb.tcisli941201 l
      where l.t$fire$l = cisli940.t$fire$l
      and   li.t$fire$l=l.t$fire$l
      and   (l.t$sour$l=2 or l.t$sour$l=8)
      and   li.t$brty$l=5),0)                               VL_PIS_IMPORTACAO,

    nvl((select sum(li.t$amnt$l) 
      from baandb.tcisli943201 li, 
           baandb.tcisli941201 l
      where l.t$fire$l = cisli940.t$fire$l
      and   li.t$fire$l=l.t$fire$l
      and   (l.t$sour$l=2 or l.t$sour$l=8)
      and   li.t$brty$l=6),0)                               VL_COFINS_IMPORTACAO,

    nvl((select sum(l.t$fght$l) 
      from baandb.tcisli941201 l
      where l.t$fire$l = cisli940.t$fire$l
      and   (l.t$sour$l=2 or l.t$sour$l=8)),0)              VL_CIF_IMPORTACAO,

  GREATEST(        
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(cisli940.t$rcd_utc, 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE),
    nvl((select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(c1.t$rcd_utc), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
        from baandb.tcisli941201 c1
        where c1.t$fire$l=cisli940.t$fire$l), TO_DATE('01-JAN-1970', 'DD-MON-YYYY')),
    nvl((select CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(max(c2.t$rcd_utc), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) 
        from baandb.tcisli943201 c2
        where c2.t$fire$l=cisli940.t$fire$l), TO_DATE('01-JAN-1970', 'DD-MON-YYYY'))) 
                                                            DT_ULT_ATUALIZACAO,

   (SELECT tcemm124.t$grid 
    FROM baandb.ttcemm124201 tcemm124
      WHERE tcemm124.t$cwoc=cisli940.t$cofc$l
      AND tcemm124.t$loco=201
      AND rownum=1)                                         CD_UNIDADE_EMPRESARIAL,

  cisli940.t$fire$l                                         NR_REFERENCIA_FISCAL,
  cisli940.t$fdtc$l                                         CD_TIPO_DOCUMENTO_FISCAL,
  cisli940.t$nfes$l                                         CD_STATUS_SEFAZ,

  (SELECT tdsls400.t$sotp                            
   FROM baandb.ttdsls400201 tdsls400
   WHERE tdsls400.t$orno=entr.t$orno$c
   group by tdsls400.t$sotp)                                CD_TIPO_ORDEM_VENDA

FROM
    baandb.tcisli940201 cisli940
    LEFT JOIN (SELECT   znsls401.t$entr$c,
              cisli245.t$fire$l,
              znsls401.t$pecl$c,
              cisli245.t$slso t$orno$c,
              znsls401.t$uneg$c,
              SUM(znsls401.t$vldi$c) t$vldi$c
          FROM
           baandb.tcisli245201 cisli245
           LEFT JOIN (select  r.t$ncia$c,
                    r.t$uneg$c,
                    r.t$pecl$c,
                    r.t$sqpd$c,
                    r.t$entr$c,
                    r.t$sequ$c,
                    r.t$orno$c,
                    r.t$pono$c
                 from baandb.tznsls004201  r
                 where r.t$entr$c=( select  r0.t$entr$c
                                    from baandb.tznsls004201  r0
                                    where r0.t$orno$c=r.t$orno$c
                                    and rownum=1
                                    and r0.t$date$c=  (select max(r1.t$date$c)
                                                         from baandb.tznsls004201  r1
                                                         where r1.t$orno$c=r0.t$orno$c))) znsls004
                              ON  znsls004.t$orno$c=cisli245.t$slso
                                                  AND znsls004.t$pono$c=cisli245.t$pono
           LEFT JOIN baandb.tznsls401201 znsls401 ON   znsls401.t$ncia$c=znsls004.t$ncia$c
                                                  AND   znsls401.t$uneg$c=znsls004.t$uneg$c
                                                  AND   znsls401.t$pecl$c=znsls004.t$pecl$c
                                                  AND   znsls401.t$sqpd$c=znsls004.t$sqpd$c
                                                  AND   znsls401.t$entr$c=znsls004.t$entr$c
                                                  AND   znsls401.t$sequ$c=znsls004.t$sequ$c
          group by
              znsls401.t$entr$c,
              cisli245.t$fire$l,
              znsls401.t$pecl$c ,
              cisli245.t$slso,
              znsls401.t$uneg$c) entr ON entr.t$fire$l=cisli940.t$fire$l,

    baandb.ttcemm124201 tcemm124,
    baandb.ttcemm030201 tcemm030

WHERE tcemm124.t$loco=201
AND   tcemm124.t$dtyp=2
AND   tcemm124.t$cwoc=cisli940.t$cofc$l
AND   tcemm030.t$eunt=tcemm124.t$grid