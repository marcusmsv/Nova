﻿SELECT
--**********************************************************************************************************************************************************
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
-- em 02/10/15 foram incluidos os campos NR_ENTREGA_CANCELADO e SQ_PEDIDO_CANCELADO #457

      CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(greatest(tdsls400.t$rcd_utc, tdsls401.t$rcd_utc), 
        'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) DT_ULT_ATUALIZACAO,
		  15 AS CD_CIA, --znsls400.t$ncia$c 
      znsls401.t$uneg$c CD_UNIDADE_NEGOCIO,
      tdsls401.t$orno NR_ORDEM,
		  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtin$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) DT_COMPRA,			
--		  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls401.t$dtep$c, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
--        AT time zone 'America/Sao_Paulo') AS DATE) DT_ENTREGA,
        CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tdsls400.T$PRDT, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE) DT_ENTREGA,
      CASE WHEN tdsls401.t$clyn=1 THEN 35 -- cancelado
        WHEN tdsls401.t$term=1 THEN 30	  -- finalizado
        WHEN tdsls401.t$modi=1 THEN 25	  -- modificado
        WHEN tdsls400.t$hdst=20 THEN	  --
				CASE WHEN nvl((Select max(atv.t$xcsq) 
					From baandb.ttdsls413602 atv 
					where atv.t$orno=tdsls401.t$orno 
					and   atv.t$pono=tdsls401.t$pono 
					and   atv.t$xcst>=15),99)=99 THEN 10 ELSE 20 END
			ELSE tdsls400.t$hdst END CD_SITUACAO_PEDIDO,
          znsls400.t$idca$c CD_CANAL_VENDA,
          ltrim(rtrim(tdsls401.t$item)) CD_ITEM,
          tdsls401.t$qoor QT_ITENS,
          tdsls401.t$pric*tdsls401.t$qoor VL_ITEM,																	
          znsls401.TOT_VLDI                                           VL_DESCONTO_INCONDICIONAL,
          znsls401.TOT_VLFR                                           VL_FRETE_CLIENTE,
          nvl((select sum(f.t$vlft$c) from baandb.tznfmd630602 f
          where f.t$pecl$c=znsls400.t$pecl$c),0) VL_FRETE_CIA,
          CASE WHEN znsls400.t$cven$c=100 THEN NULL ELSE znsls400.t$cven$c END CD_VENDEDOR,
          znsls400.t$idli$c NR_LISTA_CASAMENTO,
          'Aprovados' DS_STATUS_PAGAMENTO,        
          ' ' DT_PAGAMENTO,                -- **** DESCONSIDERAR - SOMENTE PGTO APROVADOS ESTÃO NO LN
          ' ' DS_UTM_PARCEIRO,                  -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
          ' ' DS_UTM_MIDIA,                     -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
          ' ' DS_UTM_CAMPANHA,                  -- **** DESCONSIDERAR - SERÁ EXTRAIDO DO SITE
          znsls401.TOT_VLDE                                            VL_DESPESA_ACESSORIO,          
        cast((((znsls401.t$vlun$c*znsls401.TOT_QTVE)+znsls401.TOT_VLFR-znsls401.TOT_VLDI+znsls401.TOT_VLDE) 
				/sls401p.VL_PGTO_PED)*znsls402.t$vlju$c as numeric(12,2)) VL_JUROS,															
		    cast((znsls401.t$vlun$c*znsls401.TOT_QTVE)+znsls401.TOT_VLFR-znsls401.TOT_VLDI+znsls401.TOT_VLDE+   
		    (((znsls401.t$vlun$c*znsls401.TOT_QTVE)+znsls401.TOT_VLFR-znsls401.TOT_VLDI+znsls401.TOT_VLDE)      
				/sls401p.VL_PGTO_PED)*znsls402.t$vlju$c as numeric(18,2)) VL_TOTAL_ITEM,														
          (SELECT Count(lc.t$pono)
           FROM  baandb.ttdsls401602 lc
           WHERE lc.t$orno=tdsls401.t$orno
           AND   lc.t$pono=tdsls401.t$pono
           AND   lc.t$clyn=1) QT_ITENS_CANCELADOS,
          case when tcemm030.t$euca = ' ' then substr(tcemm124.t$grid,-2,2) else tcemm030.t$euca end as CD_FILIAL,
	  tcemm124.t$grid CD_UNIDADE_EMPRESARIAL,
		  znsls401.t$tpcb$c CD_TIPO_COMBO,
      znsls401.t$pecl$c NR_PEDIDO,
      TO_CHAR(znsls401.T$ENTR$C) NR_ENTREGA,
	  znsls400.t$idco$c CD_CONTRATO_B2B,														
	  znsls400.t$idCP$c CD_CAMPANHA_B2B,
	  znsls004.t$orig$c CD_ORIGEM_PEDIDO,															
	  (select min(cisli940.t$stat$l) 
	   from baandb.tcisli940602 cisli940, baandb.tcisli245602 cisli245
	   where cisli245.t$slso=tdsls401.t$orno
	   and cisli245.t$pono=tdsls401.t$pono
	   and cisli245.t$ortp=1
	   and cisli245.t$koor=3
	   and cisli940.t$fire$l=cisli245.t$fire$l) CD_SITUACAO_NF,										
	  CASE WHEN znsls401.t$igar$c=0 THEN ltrim(rtrim(tdsls401.t$item))
	  ELSE TO_CHAR(znsls401.t$igar$c) END CD_PRODUTO,												
	CAST(tdsls401.t$pono as varchar(10)) SQ_ORDEM,													
	   tdsls400.t$sotp  CD_TIPO_ORDEM_VENDA,                                 						
  case when znsls401.TOT_QTVE<0 then 2 else 1 end                       IN_CANCELADO,
    znsls401.t$endt$c             NR_ENTREGA_CANCELADO,
    znsls401.t$sidt$c             SQ_PEDIDO_CANCELADO

FROM
        baandb.ttdsls401602 tdsls401,
	
		    ( select  a.t$ncia$c,                                  
                  a.t$uneg$c,
                  a.t$pecl$c,
                  a.t$sqpd$c,
                  a.t$entr$c,
                  a.t$item$c,
                  a.t$orno$c,
                  a.t$pono$c,
                  a.t$dtep$c,
                  a.t$vlun$c,
                  a.t$tpcb$c,
                  a.t$igar$c,
                  a.t$endt$c,
                  a.t$sidt$c,
                  sum(a.t$qtve$c) TOT_QTVE,
                  sum(a.t$vlfr$c) TOT_VLFR,
                  sum(a.t$vldi$c) TOT_VLDI,
                  sum(a.t$vlde$c) TOT_VLDE
          from    baandb.tznsls401602 a
          group by  a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$item$c,
                    a.t$orno$c,
                    a.t$pono$c,
                    a.t$dtep$c,
                    a.t$vlun$c,
                    a.t$tpcb$c,
                    a.t$igar$c,
                    a.t$endt$c,
                    a.t$sidt$c) znsls401,                    
          
          baandb.tznsls004602 znsls004,		
        baandb.ttdsls400602 tdsls400,
        baandb.ttcemm124602 tcemm124,
        baandb.ttcemm030602 tcemm030,
        baandb.tznsls400602 znsls400,
		(select distinct 																									
			znsls401t.t$ncia$c      	t$ncia$c,
			znsls401t.t$uneg$c       t$uneg$c,
			znsls401t.t$pecl$c       t$pecl$c,
			znsls401t.t$sqpd$c       t$sqpd$c,
			sum((znsls401t.t$vlun$c*znsls401t.t$qtve$c)+znsls401t.t$vlfr$c-znsls401t.t$vldi$c+znsls401t.t$vlde$c) VL_PGTO_PED		
		from baandb.tznsls401602 znsls401t
		group by
			znsls401t.t$ncia$c,																				
			znsls401t.t$uneg$c,
			znsls401t.t$pecl$c,
			znsls401t.t$sqpd$c) sls401p,																							
		(select	sum(znsls402t.t$vlju$c) t$vlju$c,
				znsls402t.t$ncia$c,
				znsls402t.t$uneg$c,
				znsls402t.t$pecl$c,
                znsls402t.t$sqpd$c
		from baandb.tznsls402602 znsls402t
		group by
				znsls402t.t$ncia$c,
				znsls402t.t$uneg$c,
				znsls402t.t$pecl$c,
                znsls402t.t$sqpd$c) znsls402																				
		
WHERE   znsls401.t$orno$c=tdsls401.t$orno
AND     znsls401.t$pono$c=tdsls401.t$pono
AND     tdsls400.t$orno=tdsls401.t$orno
AND     tcemm124.t$cwoc=tdsls400.t$cofc
AND 	tcemm030.t$eunt=tcemm124.t$grid
AND     znsls400.t$ncia$c=znsls401.t$ncia$c
AND     znsls400.t$uneg$c=znsls401.t$uneg$c
AND     znsls400.t$pecl$c=znsls401.t$pecl$c
AND     znsls400.t$sqpd$c=znsls401.t$sqpd$c
and	   sls401p.t$ncia$c=znsls401.t$ncia$c																					
and    sls401p.t$uneg$c=znsls401.t$uneg$c
and    sls401p.t$pecl$c=znsls401.t$pecl$c
and    sls401p.t$sqpd$c=znsls401.t$sqpd$c																					
and	   znsls402.t$ncia$c=znsls401.t$ncia$c
and    znsls402.t$uneg$c=znsls401.t$uneg$c
and    znsls402.t$pecl$c=znsls401.t$pecl$c
and    znsls402.t$sqpd$c=znsls401.t$sqpd$c
and     znsls004.t$ncia$c=znsls401.t$ncia$c                                     
and    znsls004.t$uneg$c=znsls401.t$uneg$c
and     znsls004.t$pecl$c=znsls401.t$pecl$c			
and     znsls004.t$orno$c=znsls401.t$orno$c  						
and     znsls004.t$pono$c=znsls401.t$pono$c                                     
and     tdsls401.t$sqnb = 0          