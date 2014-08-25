﻿-- 06-mai-2014, Fabio Ferreira, Correção timezone
--								Alteração para cia 201
-- FAF.002 - 09-mai-2014, Fabio Ferreira, Quando a data no LN é zero (01/01/1970) não é feita a conversão de timezone
--****************************************************************************************************************************************************************
SELECT
	tccom125.t$ptbp CD_PARCEIRO,
	tfcmg011.t$baoc$l CD_BANCO,
	tfcmg011.t$agcd$l NR_AGENCIA,
	tfcmg011.t$agdg$l NR_DIGITO_AGENCIA,
	tccom125.t$bano NR_CONTA,
	tccom125.t$dacc$d NR_DIGITO_CONTA,
	CASE WHEN tccom125.t$rcd_utc<TO_DATE('1990-01-01', 'YYYY-MM-DD') THEN tccom125.t$rcd_utc				--#FAF.002.sn
	ELSE CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(tccom125.t$rcd_utc, 'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
    AT time zone sessiontimezone) AS DATE) 
	END DT_ULT_ATUALIZACAO																			--#FAF.002.en
FROM
	baandb.ttccom125201 tccom125,
	baandb.ttfcmg011201 tfcmg011
WHERE tfcmg011.t$bank=tccom125.t$brch
order by 1
