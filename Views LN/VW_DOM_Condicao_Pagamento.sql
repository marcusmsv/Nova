-- FAF.099 - Fabio Ferreira, 02-jun-2014, Fabio Ferreira, 	Inclus�o do tipo de per�odo e o maior n�mero de per�odos
--************************************************************************************************************************************************************
SELECT
  1 AS CD_CIA,
  tcmcs013.t$cpay CD_CONDICAO_PAGAMENTO,
  tcmcs013.t$dsca DS_CONDICAO_PAGAMENTO,
  CASE WHEN tcmcs220.t$ptyp=1 THEN 'DIAS' ELSE 'MESES' END CD_TIPO_PERIODO,				--#FAF.099.sn
  tcmcs221.t$nods NR_PERIODO															--#FAF.099.en
FROM baandb.ttcmcs013201 tcmcs013,
		baandb.ttcmcs220201 tcmcs220,														--#FAF.099.sn
		(select a.t$pash, a.t$nods from baandb.ttcmcs221201 a
		where a.t$seqn = (	select max(b.t$seqn) from baandb.ttcmcs221201 b
							where b.t$pash=a.t$pash						)) tcmcs221
WHERE
		tcmcs220.t$pash = tcmcs013.t$pash
AND		tcmcs221.t$pash = tcmcs220.t$pash											--#FAF.099.en
order by 1,2