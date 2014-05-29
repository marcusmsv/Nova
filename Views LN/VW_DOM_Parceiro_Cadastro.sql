-- FAF.003 - 12-mai-2014, Fabio Ferreira, Exclus�o dos campos UF e Pais e altera��o do alias COD_CIDADE
-- FAF.005 - 12-mai-2014, Fabio Ferreira, 	Convers�o de timezone
--											Retirado os campos TEL, FAX, MATRIZ
--	#FAF.091 - 29-mai-2014,	Fabio Ferreira,	Excluir CNPJ_CPF_GRUPO
--****************************************************************************************************************************************************************
SELECT DISTINCT 
       bspt.t$bpid CD_PARCEIRO,
       addr.t$fovn$l NR_CNPJ_CPF,
       bspt.t$nama NM_PARCEIRO,
       bspt.t$seak NM_APELIDO,
       addr.t$ftyp$l CD_TIPO_CLIENTE,
       CASE
         WHEN Nvl(trnp.t$cfrw,' ')!=' ' then 10
         WHEN Nvl(fabr.t$cmnf,' ')!=' ' then 11
         ELSE bspt.t$bprl
       END CD_TIPO_CADASTRO,
--       addp.t$fovn$l NR_CNPJ_CPF_GRUPO,															--#FAF.091.o
--       bspt.t$crdt DT_CADASTRO,																	--#FAF.005.o
		CAST((FROM_TZ(CAST(TO_CHAR(bspt.t$crdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.005.n
		AT time zone sessiontimezone) AS DATE) DT_CADASTRO,											--#FAF.005.n
--       bspt.t$lmdt DT_ATUALIZACAO,																--#FAF.005.o
		CAST((FROM_TZ(CAST(TO_CHAR(bspt.t$lmdt, 'DD-MON-YYYY HH:MI:SS AM') AS TIMESTAMP), 'GMT') 	--#FAF.005.n
		AT time zone sessiontimezone) AS DATE) DT_ATUALIZACAO,										--#FAF.005.n
--       addr.t$telp TEL1,																			--#FAF.005.o
--       addr.t$telx TEL2,																			--#FAF.005.o
--       addr.t$tefx NR_FAX,																			--#FAF.005.o
       bspt.t$okfi$c IN_IDONEO,
--       CASE WHEN addp.t$cadr=addr.t$cadr THEN 'MATRIZ' ELSE 'FILIAL' END NM_MATRIZ_FILIAL,			--#FAF.005.o
	   bspt.t$prst CD_STATUS
FROM ttccom100201 bspt
--LEFT JOIN ttccom130201 addp ON addp.t$cadr = bspt.t$cadr											--#FAF.091.so
--LEFT JOIN ttccom133201 adbp ON adbp.t$bpid = bspt.t$bpid
--LEFT JOIN ttccom130201 addr ON addr.t$cadr = adbp.t$cadr											--#FAF.091.eo
LEFT JOIN ttccom130201 addr ON addr.t$cadr = bspt.t$cadr											--#FAF.091.n
LEFT JOIN ttcmcs080201 trnp ON trnp.t$suno = bspt.t$bpid -- rel com transportadoras
LEFT JOIN ttcmcs060201 fabr ON fabr.t$otbp = bspt.t$bpid -- rel com fabricantes
order by 1