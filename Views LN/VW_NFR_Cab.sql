﻿SELECT
  1                                              CD_CIA,
  CASE WHEN 
    (SELECT tcemm030.t$euca 
      FROM baandb.ttcemm124201 tcemm124, 
           baandb.ttcemm030201 tcemm030
      WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
        AND tcemm030.t$eunt=tcemm124.t$grid
        AND tcemm124.t$loco=201
        AND rownum=1) = ' ' 
  THEN SUBSTR((SELECT tcemm124.t$grid 
      FROM baandb.ttcemm124201 tcemm124, 
           baandb.ttcemm030201 tcemm030
      WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
        AND tcemm124.t$loco=201 
        AND rownum=1),5,2) 
  ELSE (SELECT tcemm030.t$euca 
      FROM baandb.ttcemm124201 tcemm124, 
           baandb.ttcemm030201 tcemm030
      WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
        AND tcemm030.t$eunt=tcemm124.t$grid
        AND tcemm124.t$loco=201
        AND rownum=1) END                         CD_FILIAL,	
  (SELECT tdrec947.t$rcno$l 
    FROM baandb.ttdrec947201 tdrec947
    WHERE tdrec947.t$fire$l=tdrec940.t$fire$l
    AND rownum=1)                         NR_NFR,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$idat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_NFR,
  tdrec940.t$rfdt$l                               CD_TIPO_OPERACAO,
  tdrec940.t$bpid$l                               CD_FORNECEDOR,
  nvl(cisli940.t$docn$l, tdrec940.t$docn$l)       NR_NF_RECEBIDA,
  nvl(cisli940.t$seri$l, tdrec940.t$seri$l)       NR_SERIE_NF_RECEBIDA,
  tdrec940.t$doty$l                               CD_TIPO_NF,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$date$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_EMISSAO_NF_RECEBIDA,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$odat$l, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_SAIDA_NF_RECEBIDA,	 
  tdrec940.t$opfc$l                               CD_NATUREZA_OPERACAO,
  tdrec940.t$opor$l                               SQ_NATUREZA_OPERACAO,
  CASE WHEN tdrec940.t$opor$l='1556' 
    THEN 1 ELSE 2 END                             IN_MERC_UTILIZADA_CONSUMO,
  (Select a.t$fire$l 
    from baandb.ttdrec944201 a, 
         baandb.ttdrec940201 b
    where b.t$fire$l=a.t$fire$l 
      AND b.T$RFDT$L=31
      AND a.T$REFR$L=tdrec940.t$fire$l
      AND rownum=1)                               NR_NFR_COMPLEMENTO,	
  tdrec940.t$cpay$l                               CD_CONDICAO_PAGAMENTO,
  tdrec940.t$gtam$l                               VL_MERCADORIA,
  (SELECT tdrec949.t$base$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=1)                    VL_BASE_ICMS,
  (SELECT tdrec949.t$amnt$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=1)                    VL_ICMS,
  (SELECT tdrec949.t$amnt$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=2)                    VL_ICMS_ST,
  (SELECT sum(tdrec942.t$amnr$l) 
    FROM baandb.ttdrec942201 tdrec942
    WHERE tdrec942.t$fire$l=tdrec940.t$fire$l
      AND tdrec942.t$brty$l=1)                    VL_ICMS_DESTACADO,	
  (SELECT tdrec949.t$base$l
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=3)                    VL_BASE_IPI,
  (SELECT tdrec949.t$amnt$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=3)                    VL_IPI,
  (SELECT sum(tdrec942.t$amnr$l) 
    FROM baandb.ttdrec942201 tdrec942
    WHERE tdrec942.t$fire$l=tdrec940.t$fire$l
      AND tdrec942.t$brty$l=3)                    VL_IPI_DESTACADO,
  nvl((select sum(a.t$tamt$l) 
    from baandb.ttdrec941201 a, 
         baandb.ttcibd001201 b
    where a.t$fire$l=tdrec940.t$fire$l													
      and b.t$item=a.t$item$l
      and b.t$kitm=5),0)                          VL_SERVICO,
  tdrec940.t$gexp$l                               VL_DESPESA,
  tdrec940.t$addc$l                               VL_DESCONTO,
  (SELECT tdrec949.t$amnt$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=7)                    VL_ISS,
  tdrec940.t$fght$l                               VL_FRETE,
  tdrec940.t$tfda$l                               VL_TOTAL_NF,
  tdrec940.t$gwgt$l                               VL_PESO_BRUTO,
  nvl((select t.t$text 
    from baandb.ttttxt010201 t 
    where t$clan='p'
      AND t.t$ctxt=tdrec940.t$obse$l
      and rownum=1),' ')                          DS_OBSERVACAO_NFR,
  tdrec940.t$stat$l                               CD_SITUACAO_NFR,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR
    (GREATEST(tdrec940.t$date$l, tdrec940.t$idat$l, 
              tdrec940.t$odat$l, tdrec940.t$adat$l), 
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  
        AT time zone 'America/Sao_Paulo') AS DATE) DT_SITUACAO,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdrec940.t$rcd_utc, 
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT') 
      AT time zone 'America/Sao_Paulo') AS DATE)  DT_ULT_ATUALIZACAO,
  tdrec940.t$lipl$l                               COD_CAMINHAO,
  CASE WHEN nvl(tccom966.t$insu$l,' ') = ' ' 
    THEN 2 ELSE 1 END                             IN_SUFRAMA,	
  (SELECT tdrec949.t$amnt$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=5)                    VL_PIS,
  (SELECT tdrec949.t$amnt$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=6)                    VL_COFINS,
  nvl((SELECT tdrec949.t$amnt$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=13),0)                VL_CSLL,
  (SELECT tdrec949.t$base$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
    AND tdrec949.t$brty$l=16)                     VL_BASE_IMPOSTO_IMPORTACAO,
  (SELECT tdrec949.t$amnt$l 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
      AND tdrec949.t$brty$l=16)                   VL_IMPOSTO_IMPORTACAO,
  tdrec940.t$cchr$l                               VL_DESPESA_ADUANEIRA,
  nvl((select sum(l.t$gexp$l) 
    from baandb.ttdrec941201 l
    where	l.t$fire$l = tdrec940.t$fire$l
      and (l.t$sour$l=2 or l.t$sour$l=8)),0)      VL_ADICIONAL_IMPORTACAO,
  nvl((select sum(li.t$amnt$l) 
    from baandb.ttdrec942201 li, baandb.ttdrec941201 l
    where	l.t$fire$l = tdrec940.t$fire$l
      and l.t$fire$l=li.t$fire$l
      and (l.t$sour$l=2 or l.t$sour$l=8)
      and li.t$brty$l=5),0)                       VL_PIS_IMPORTACAO,
  nvl((select sum(li.t$amnt$l) 
    from baandb.ttdrec942201 li, baandb.ttdrec941201 l
    where	l.t$fire$l = tdrec940.t$fire$l
      and l.t$fire$l=li.t$fire$l
      and (l.t$sour$l=2 or l.t$sour$l=8)
      and li.t$brty$l=6),0)                       VL_COFINS_IMPORTACAO,	
  CAST(nvl((select sum(l.t$fght$l) 
    from baandb.ttdrec941201 l
    where	l.t$fire$l = tdrec940.t$fire$l
      and l.t$crpd$l = 1),0) as numeric (18,2))   VL_CIF,
  nvl((select lr.t$mdev$c 
    from baandb.twhinh312201 lr, 
         baandb.ttdrec947201 rf
    where rf.t$fire$l=tdrec940.t$fire$l
      and	lr.t$rcno=rf.t$rcno$l
      and lr.t$rcln=rf.t$rcln$l
      and lr.t$mdev$c!=' '
      and rownum=1),' ')                          DS_MOTIVO_DEVOLUCAO_ATO,	
  nvl((Select max(d.t$crpd$l) 
    from baandb.ttdrec941201 d
    where d.t$fire$l=tdrec940.t$fire$l),2)        CD_TIPO_FRETE,																
  nvl((SELECT tdrec949.t$isco$c 
    FROM baandb.ttdrec949201 tdrec949
    WHERE tdrec949.t$fire$l=tdrec940.t$fire$l
    AND tdrec949.t$brty$l=2),2)                   IN_ICMS_ST_SEM_CONVENIO,
  (SELECT tcemm124.t$grid 
    FROM baandb.ttcemm124201 tcemm124, 
         baandb.ttcemm030201 tcemm030
    WHERE tcemm124.t$cwoc=tdrec940.t$cofc$l
      AND tcemm124.t$loco=201 
      AND rownum=1)                               CD_UNIDADE_EMPRESARIAL,
  tdrec940.t$fire$l                               NR_REFERENCIA_FISCAL,
  nvl((select ca.t$recd$c 
    from baandb.twhinh300201 ca										
    where ca.t$fire$c=tdrec940.t$fire$l
      and rownum=1),' ')                          NR_RECEB_DOCTO_WMS,
  tdrec940.t$fdtc$l                               CD_TIPO_DOC_FISCAL

FROM baandb.ttdrec940201 tdrec940

	LEFT JOIN baandb.ttccom966201 tccom966 
         ON tccom966.t$comp$d=tdrec940.t$fovn$l

	LEFT JOIN baandb.ttdrec940201 tdrec940r 
         ON tdrec940r.t$fire$l=tdrec940.t$rref$l

	LEFT JOIN (	select min(a.t$rfdv$c) rfdv, a.t$fire$l from baandb.ttdrec941201 a
                where a.t$rfdv$c!=' '
                group by a.t$fire$l) REFDEV	
         ON REFDEV.t$fire$l = tdrec940r.t$fire$l
	
  LEFT JOIN baandb.tcisli940201 cisli940 	
  ON cisli940.t$fire$l = REFDEV.rfdv

WHERE tdrec940.t$rfdt$l not in (3,5,8,13,16,22,33)
AND tdrec940.t$stat$l>3