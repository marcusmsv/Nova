
SELECT
  DISTINCT
    trim(tcibd001.t$item)    
                       NUM_ITEM,
    tcibd001.t$dsca    DESC_ITEM,
    tdipu001.t$prip    PRECO_COMPRA,
    tcibd001.t$citg    NUM_GRUPO_ITEM,
    tcmcs023.t$dsca    DESC_GRUPO_ITEM,
    tdipu001.t$otbp    NUM_FORNECEDOR,
    tccom100.t$nama    DESC_FORNECEDOR,
    tcibd001.t$cean    NUM_EAN,
    tcibd001.t$seab    CHAVE_DE_BUSCA_II,
    
    CASE 
    WHEN tcibd001.t$csig = '' OR tcibd001.t$csig = 'REA' OR tcibd001.t$csig = ' ' THEN 'Ativo'
    WHEN tcibd001.t$csig  ='SUS' THEN 'Suspenso'
    WHEN tcibd001.t$csig  ='CAN' THEN 'Cancelado'
    WHEN tcibd001.t$csig  ='001' THEN 'VerificaÃ§Ã£o Fiscal'
    END SITUACAO_ITEM,
    
    tccom130.t$fovn$l  CNPJ_FORNECEDOR,
    tccom130.t$nama    NOME_FORNECEDOR,
    tcibd001.t$ceat$l  NUM_EAN_GTIN,
    tcibd200.t$mioq    QTDE_MIN_ORDEM,
    tcibd001.t$espe$c  TIPO_ITEM,
    iTABLE.DESC_TIPO_ITEM   ITEM_ESPECIAL,
    tcibd001.t$mdfb$c  MODELO_FABRICANTE,
    tdipu001.t$suti    TEMPO_FORNECIMENTO,
    znwmd200.t$cwar$c  ARMAZEM,
    tdipu001.t$ixdn$c  TIPO_XD_NOVA,
    case when tdipu001.t$ixdn$c = 3 then
        '3-Vazio'
    else
        iTIPOXD.DESCR end     DECR_TIPO_XD_NOVA,
 
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znwmd200.t$rcd_utc,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                       DT_ALTERCAO,
    
    CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znwmd200.t$dtin$c,
      'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
        AT time zone 'America/Sao_Paulo') AS DATE)
                       DT_ARQ,
      
    znwmd200.T$qtdf$c  QT_ARQUIVO,
    znwmd200.T$prit$c  TEMPO_REPOS_ARQ,
    tcemm030.t$dsca    ESTABELEC,
    
    case when tdipu001.t$ixdn$c = 3 then
        '3-Vazio'
    else
        TO_CHAR(tdipu001.t$ixdn$c) ||
        '-'  || 
        iTIPOXD.DESCR end       DECRICAO_ITEM_XD_NOVA,
        tcibd200.t$cwar || '-' || tcmcs003.t$dsca        
                                FILIAL,
    CASE WHEN znsng064.t$skvv$o IS NULL or znsng064.t$skvv$o = ' ' THEN
         'Sem Sinergia'
    ELSE znsng064.t$skvv$o END  SKU_VIA_VAREJO,
    STATUS.DESCR                STATUS_ENTREGA_CLIENTE

FROM baandb.ttcibd001301 tcibd001 

 LEFT JOIN baandb.tznwmd200301 znwmd200
       ON znwmd200.t$item$c = tcibd001.t$item
  
 INNER JOIN baandb.ttcibd200301 tcibd200
        ON tcibd200.t$item = tcibd001.t$item  
  
 LEFT JOIN baandb.ttcmcs023301 tcmcs023
        ON tcmcs023.t$citg = tcibd001.t$citg
  
 INNER JOIN baandb.ttdipu001301 tdipu001 
        ON tdipu001.t$item = tcibd001.t$item
  
 LEFT JOIN baandb.ttccom100301 tccom100
        ON tccom100.t$bpid = tdipu001.t$otbp
  
 LEFT JOIN baandb.ttccom130301 tccom130
        ON tccom130.t$cadr = tccom100.t$cadr      
  
 LEFT JOIN baandb.ttcemm112301 tcemm112  
        ON tcemm112.t$waid = znwmd200.t$cwar$c
 
 LEFT JOIN baandb.ttcemm030301 tcemm030  
        ON tcemm030.t$eunt = tcemm112.t$grid
 
 LEFT JOIN baandb.tznsng064301 znsng064
        ON znsng064.t$item$o = tcibd001.t$item
 
 LEFT JOIN baandb.ttcibd200301 tcibd200
        ON tcibd200.t$item = tcibd001.t$item
 
 LEFT JOIN baandb.ttcmcs003301 tcmcs003
        ON tcmcs003.t$cwar = tcibd200.t$cwar
        
 LEFT JOIN ( SELECT d.t$cnst CODE_STAT, 
                    l.t$desc DESC_TIPO_ITEM
               FROM baandb.tttadv401000 d, 
                    baandb.tttadv140000 l 
              WHERE d.t$cpac = 'zn' 
                AND d.t$cdom = 'ibd.espe.c'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'zn'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac )) iTABLE
        ON iTABLE.CODE_STAT = tcibd001.t$espe$c
       
 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'zn'
                AND d.t$cdom = 'ipu.ixdn.c'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'zn'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) iTIPOXD
        ON iTIPOXD.CODE = tdipu001.t$ixdn$c

 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'zn'
                AND d.t$cdom = 'sng.stme.o'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'zn'
                AND l.t$clab = d.t$za_clab
                AND rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv401000 l1 
                                          where l1.t$cpac = d.t$cpac 
                                            and l1.t$cdom = d.t$cdom )
                AND rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) || 
                                                    rpad(l1.t$cust,4)) 
                                           from baandb.tttadv140000 l1 
                                          where l1.t$clab = l.t$clab 
                                            and l1.t$clan = l.t$clan 
                                            and l1.t$cpac = l.t$cpac ) ) STATUS
        ON STATUS.CODE = znsng064.t$stat$o

WHERE tdipu001.t$ixdn$c IN (:XD)
  AND tcibd001.t$citg IN (:Depto)  
  AND ( (tccom130.t$fovn$l like '%' || Trim(:CNPJ) || '%') OR (:CNPJ is null) )
