﻿SELECT
-- O campo CD_CIA foi incluido para diferenciar NIKE(13) E BUNZL(15)
--**********************************************************************************************************************************************************
  CAST(15 AS INT) AS CD_CIA,
  tcmcs013.t$cpay CD_CONDICAO_PAGAMENTO,
  tcmcs013.t$dsca DS_CONDICAO_PAGAMENTO,
  CASE WHEN tcmcs220.t$ptyp=1 THEN 'DIAS' ELSE 'MESES' END CD_TIPO_PERIODO,				
  tcmcs221.t$nods NR_PERIODO															
FROM baandb.ttcmcs013201 tcmcs013,  --tabela compartilhada
		baandb.ttcmcs220201 tcmcs220,   --tabela compartilhada														
		(select a.t$pash, a.t$nods from baandb.ttcmcs221201 a
		where a.t$seqn = (	select max(b.t$seqn) from baandb.ttcmcs221201 b --tabela compartilhada
							where b.t$pash=a.t$pash						)) tcmcs221
WHERE
		tcmcs220.t$pash = tcmcs013.t$pash
AND		tcmcs221.t$pash = tcmcs220.t$pash											
order by 1,2