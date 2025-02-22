﻿
SELECT 

  d.t$cnst  CD_TIPO_OPERACAO,
  l.t$desc  DS_TIPO_OPERACAO,
  'NFR'     CD_MODULO	

FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l

WHERE d.t$cpac='td'	
AND d.t$cdom='rec.trfd.l'
AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                   (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                    from baandb.tttadv401000 l1 
                    where l1.t$cpac=d.t$cpac 
                    AND l1.t$cdom=d.t$cdom)
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='td'
AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                    (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                      from baandb.tttadv140000 l1 
                      where l1.t$clab=l.t$clab 
                      AND l1.t$clan=l.t$clan 
                      AND l1.t$cpac=l.t$cpac)
                      
UNION	

SELECT 

  d.t$cnst  CD_TIPO_OPERACAO,
  l.t$desc  DS_TIPO_OPERACAO,
  'NFV'     CD_MODULO

FROM baandb.tttadv401000 d,
     baandb.tttadv140000 l

WHERE d.t$cpac='ci'
AND d.t$cdom='sli.tdff.l'
AND rpad(d.t$vers,4) || rpad(d.t$rele,2) || rpad(d.t$cust,4)=
                   (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele, 2) || rpad(l1.t$cust,4) ) 
                    from baandb.tttadv401000 l1 
                    where l1.t$cpac=d.t$cpac 
                    AND l1.t$cdom=d.t$cdom)
AND l.t$clab=d.t$za_clab
AND l.t$clan='p'
AND l.t$cpac='ci'
AND rpad(l.t$vers,4) || rpad(l.t$rele,2) || rpad(l.t$cust,4)=
                    (select max(rpad(l1.t$vers,4) || rpad(l1.t$rele,2) || rpad(l1.t$cust,4) ) 
                      from baandb.tttadv140000 l1 
                      where l1.t$clab=l.t$clab 
                      AND l1.t$clan=l.t$clan 
                      AND l1.t$cpac=l.t$cpac)
                      
order by 1