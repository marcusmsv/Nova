--	FAF.003 - 12-mai-2014, Fabio Ferreira, 	Icluido os tipos de operação de saida
--	FAF.008 - 21-mai-2014, Fabio Ferreira, 	Correção os registros do módulo NR estavam mostrando os registros de NF
--*******************************************************************************************************************************************
SELECT d.t$cnst CD_TIPO_OPERACAO,
       l.t$desc DS_TIPO_OPERACAO,
	   'NFR' CD_MODULO													--#FAF.003.n
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
--WHERE d.t$cpac='ci'												--#FAF.008.o
WHERE d.t$cpac='td'													--#FAF.008.n
--AND d.t$cdom='sli.tdff.l'											--#FAF.008.o
AND d.t$cdom='rec.trfd.l'											--#FAF.008.n
AND d.t$vers='B61U'
AND d.t$rele='a7'
AND d.t$cust='glo1'
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
--AND l.t$cpac='tf'													--#FAF.008.o
AND l.t$cpac='td'													--#FAF.008.n
AND l.t$vers='B61U'
AND l.t$rele='a7'
AND l.t$cust='glo1'
UNION																--#FAF.003.sn
SELECT d.t$cnst CD_TIPO_OPERACAO,
       l.t$desc DS_TIPO_OPERACAO,
	   'NFV' CD_MODULO
FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l
WHERE d.t$cpac='ci'
AND d.t$cdom='sli.tdff.l'
AND d.t$vers || d.t$rele || d.t$cust=(select max(l1.t$vers || l1.t$rele || l1.t$cust ) 
                                      from baandb.tttadv401000 l1 
                                      where l1.t$cpac=d.t$cpac 
                                      AND l1.t$cdom=d.t$cdom)
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='ci'
AND l.t$vers || l.t$rele || l.t$cust=(select max(l1.t$vers || l1.t$rele || l1.t$cust ) 
                                      from baandb.tttadv140000 l1 
                                      where l1.t$clab=l.t$clab 
                                      AND l1.t$clan=l.t$clan 
                                      AND l1.t$cpac=l.t$cpac)
order by 1													--#FAF.003.en
