SELECT tfcmg101.t$btno                                     NUME_LOTE,
       ABS(LOTE.VALO_LOTE)                                 VALO_LOTE,
                                                       
       tfcmg101.t$ninv                                     NUME_TITULO,
       NVL(tfacp200.t$docn$l, tfacr200.t$docn$l)           NUME_NF,
       tfcmg101.t$ttyp         CODE_TRANSAC,
       tfcmg101.t$dued$l       DATA_VENC,
       regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')     CNPJ_FORN,
       Trim(tccom100.t$nama)                               NOME_FORN,
	   
       CASE WHEN tfcmg101.t$tadv IN (3, 4) -- 3-Fatura de venda; 4-Nota de crédito de venda
              THEN (tfcmg101.t$amnt - tfcmg101.t$ramn$l) * (-1)
            ELSE   (tfcmg101.t$amnt - tfcmg101.t$ramn$l) 
       END                                                 VALO_PAGA,
	   
       CASE WHEN tfcmg101.t$tadv IN (3, 4) -- 3-Fatura de venda; 4-Nota de crédito de venda
              THEN (tfcmg101.t$amnt$l) * (-1)
            ELSE tfcmg101.t$amnt$l  
       END                                                 VALO_BRUTO,
	   
       tfcmg101.t$post                                     CODE_LIQUID,
       tfcmg101.t$paym                                     CODE_METPGTO,
       
       CASE WHEN tfcmg003.t$typp = 2
              THEN 1
            ELSE   2
        END                                                CODE_TIPOPGTO,
       
       tfcmg101.t$bank                                     NUME_BANCO,
       tfcmg011.t$agcd$l                                   CODE_AGENCIA,
       tfcmg001.t$bano                                     CODE_CONTA,
       tfcmg101.t$mopa$d                                   CODE_MODAL,
       iTABLE.                                             DESC_MODAL,
       tfcmg101.t$plan                                     DATA_PAGAM,
       tfcmg109.t$stpp                                     CODE_STATUS,
       iSTATUS.DESCR                                       DESCR_STATUS,
       tfcmg101.t$tadv                                     CODE_TIPO_ACONSELHAMENTO,
       
       ACONSELHAMENTO.                                     DESCR_TIPO_ACONSELHAMENTO,

       CASE WHEN tfcmg101.t$tadv = 5     --Pagamento Adiantado
              THEN CASE WHEN tfcmg103.t$paid = 1 
                          THEN 5         -- Pago
                        ELSE   99        -- Criado
                    END   
            WHEN tfcmg101.t$tadv = 4     --Nota de Credito de Venda
              THEN tfacr201.t$rpst$l
            ELSE   NVL(tfacp201.t$pyst$l, tfcmg104.t$stst) 
       END                                                 CODE_STAT_PRG,
       
       CASE WHEN tfcmg101.t$tadv = 5     --Pagamento Adiantado
              THEN CASE WHEN tfcmg103.t$paid = 1
                          THEN 'Pago'
                        ELSE   'Criado'
                   END
            WHEN tfcmg101.t$tadv in (3,4) --Nota de Credito de Venda (Livre, Não aplicável)
              THEN StatusCreditoVenda.DESC_STATUSCREDITOVENDA
            ELSE iPrgStat.DESCR
       END                                                 DESCR_STAT_PRG,
       
       CASE WHEN tflcb230.t$send$d = 0
              THEN tflcb230.t$stat$d
            ELSE tflcb230.t$send$d
       END                                                 CODE_STAT_ARQ,
       
       iStatArq.DESCR                                      DESCR_STAT_ARQ

FROM       baandb.ttfcmg101302   tfcmg101

INNER JOIN baandb.ttccom100302   tccom100
        ON tccom100.T$BPID = tfcmg101.t$ifbp

INNER JOIN baandb.ttccom130302   tccom130
        ON tccom130.t$cadr = tccom100.t$cadr

INNER JOIN ( SELECT SUM(t.t$amnt) VALO_LOTE,
                    t.t$ninv,
                    t.t$ttyp,
                    t.t$btno
               FROM baandb.ttfcmg101302  t
           GROUP BY t.t$ninv,
                    t.t$ttyp,
                    t.t$btno ) LOTE
        ON LOTE.t$ninv = tfcmg101.t$ninv
       AND LOTE.t$ttyp = tfcmg101.t$ttyp
       AND LOTE.t$btno = tfcmg101.t$btno

INNER JOIN baandb.ttfcmg109302   tfcmg109
        ON tfcmg109.t$btno = tfcmg101.t$btno

INNER JOIN baandb.ttfcmg003301  tfcmg003
        ON tfcmg003.t$paym = tfcmg101.t$paym

 LEFT JOIN baandb.ttfacp201302  tfacp201
        ON tfacp201.t$ttyp = tfcmg101.t$ttyp
       AND tfacp201.t$ninv = tfcmg101.t$ninv
       AND tfacp201.t$schn = tfcmg101.t$schn

 LEFT JOIN baandb.ttfacp200302  tfacp200
        ON tfacp200.t$ttyp = tfacp201.t$ttyp
       AND tfacp200.t$ninv = tfacp201.t$ninv

  LEFT JOIN baandb.ttfacr200301     tfacr200
         ON tfacr200.t$ttyp = tfcmg101.t$ttyp
        AND tfacr200.t$ninv = tfcmg101.t$ninv
        AND tfacr200.t$line = 0
        AND tfacr200.t$lino = 0

 LEFT JOIN baandb.ttfcmg103302  tfcmg103
        ON tfcmg103.t$btno = tfcmg101.t$btno
       AND tfcmg103.t$ptbp = tfcmg101.t$ptbp
       AND tfcmg103.t$docn = tfcmg101.t$pdoc
       AND tfcmg103.t$ttyp = tfcmg101.t$ptyp

 LEFT JOIN baandb.ttfcmg001302  tfcmg001
        ON tfcmg001.t$bank = tfcmg101.t$bank

 LEFT JOIN baandb.ttfcmg011302  tfcmg011
        ON tfcmg011.t$bank = tfcmg001.t$brch

 LEFT JOIN baandb.ttfacp201302  tfacp201
        ON tfacp201.t$ttyp = tfcmg101.t$ttyp
       AND tfacp201.t$ninv = tfcmg101.t$ninv
       AND tfacp201.t$schn = tfcmg101.t$schn

 LEFT JOIN baandb.ttfacr201302  tfacr201
        ON tfacr201.t$ttyp = tfcmg101.t$ttyp
       AND tfacr201.t$ninv = tfcmg101.t$ninv
       AND tfacr201.t$recd = tfcmg101.t$dued$l
       AND tfacr201.t$schn = tfcmg101.t$schn

 LEFT JOIN ( select distinct
                    iDOMAIN.t$cnst CODE_STATUSCREDITOVENDA,
                    iLABEL.t$desc  DESC_STATUSCREDITOVENDA
               from baandb.tttadv401000 iDOMAIN,
                    baandb.tttadv140000 iLABEL
              where iDOMAIN.t$cpac = 'tf'
                and iDOMAIN.t$cdom = 'acr.strp.l'
                and iLABEL.t$clan = 'p'
                and iLABEL.t$cpac = 'tf'
                and iLABEL.t$clab = iDOMAIN.t$za_clab
                and rpad(iDOMAIN.t$vers,4) ||
                    rpad(iDOMAIN.t$rele,2) ||
                    rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                          rpad(l1.t$rele,2) ||
                                                          rpad(l1.t$cust,4))
                                                 from baandb.tttadv401000 l1
                                                where l1.t$cpac = iDOMAIN.t$cpac
                                                  and l1.t$cdom = iDOMAIN.t$cdom )
                and rpad(iLABEL.t$vers,4) ||
                    rpad(iLABEL.t$rele,2) ||
                    rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                         rpad(l1.t$rele,2) ||
                                                         rpad(l1.t$cust,4))
                                                from baandb.tttadv140000 l1
                                               where l1.t$clab = iLABEL.t$clab
                                                 and l1.t$clan = iLABEL.t$clan
                                                 and l1.t$cpac = iLABEL.t$cpac ) ) StatusCreditoVenda
        ON tfacr201.t$rpst$l = StatusCreditoVenda.CODE_STATUSCREDITOVENDA

 LEFT JOIN baandb.ttfcmg104302  tfcmg104
        ON tfcmg104.t$orno = tfcmg101.t$ninv
       AND tfcmg104.t$ifbp = tfcmg101.t$ifbp

 LEFT JOIN ( select sum(a.t$amti) JUROS,
                    a.t$ttyp,
                    a.t$ninv
               from baandb.ttfacp200302   a
              where a.t$tpay = 5
           group by a.t$ttyp, a.t$ninv )  ACP200
        ON ACP200.t$ttyp = tfcmg101.t$ttyp
       AND ACP200.t$ninv = tfcmg101.t$ninv

 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'acp.pyst.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac )

              UNION

             SELECT d.t$cnst*10 CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.stst'
                AND l.t$clab = d.t$za_clab
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) iPrgStat
        ON iPrgStat.CODE = nvl(tfacp201.t$pyst$l, tfcmg104.t$stst*10)

 LEFT JOIN ( SELECT a.t$ttyp$d,
                    a.t$ninv$d,
                    a.t$ptyp$d,
                    a.t$docn$d,
                    max(a.t$stat$d) t$stat$d,
                    max(a.t$send$d) t$send$d
               FROM baandb.ttflcb230302  a
              WHERE a.t$sern$d = ( select max(b.t$sern$d)
                                     from baandb.ttflcb230302  b
                                    where b.t$ttyp$d = a.t$ttyp$d
                                      and b.t$ninv$d = a.t$ninv$d
                                      and b.t$ptyp$d = a.t$ptyp$d
                                      and b.t$docn$d = a.t$docn$d )
           GROUP BY a.t$ttyp$d,
                    a.t$ninv$d,
                    a.t$ptyp$d,
                    a.t$docn$d ) tflcb230
        ON tflcb230.t$ttyp$d = tfcmg101.t$ttyp
       AND tflcb230.t$ninv$d = tfcmg101.t$ninv
       AND tflcb230.t$ptyp$d = tfcmg101.t$ptyp
       AND tflcb230.t$docn$d = tfcmg101.t$pdoc

 LEFT JOIN ( SELECT 0                 CODE,
                    'Não vinculado'   DESCR
               FROM Dual

              UNION

             SELECT d.t$cnst CODE,
                    l.t$desc DESCR
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.stat.l'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) iStatArq
        ON iStatArq.CODE = NVL(CASE WHEN tflcb230.t$send$d = 0
                                      THEN tflcb230.t$stat$d
                                    ELSE   tflcb230.t$send$d
                                END, 0)

LEFT JOIN ( SELECT iDOMAIN.t$cnst CODE_MODAL,
                   iLABEL.t$desc DESC_MODAL
              FROM baandb.tttadv401000 iDOMAIN,
                   baandb.tttadv140000 iLABEL
             WHERE iDOMAIN.t$cpac = 'tf'
               AND iDOMAIN.t$cdom = 'cmg.mopa.d'
               AND iLABEL.t$clan = 'p'
               AND iLABEL.t$cpac = 'tf'
               AND iLABEL.t$clab = iDOMAIN.t$za_clab
               AND rpad(iDOMAIN.t$vers,4) ||
                   rpad(iDOMAIN.t$rele,2) ||
                   rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                         rpad(l1.t$rele,2) ||
                                                         rpad(l1.t$cust,4))
                                                from baandb.tttadv401000 l1
                                               where l1.t$cpac = iDOMAIN.t$cpac
                                                 and l1.t$cdom = iDOMAIN.t$cdom )
               AND rpad(iLABEL.t$vers,4) ||
                   rpad(iLABEL.t$rele,2) ||
                   rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                        rpad(l1.t$rele,2) ||
                                                        rpad(l1.t$cust,4))
                                               from baandb.tttadv140000 l1
                                              where l1.t$clab = iLABEL.t$clab
                                                and l1.t$clan = iLABEL.t$clan
                                                and l1.t$cpac = iLABEL.t$cpac ) ) iTABLE
        ON tfcmg101.t$mopa$d = iTABLE.CODE_MODAL

 LEFT JOIN ( SELECT d.t$cnst CODE,
                    l.t$desc DESCR,
                    'CAP' CD_MODULO
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.stpp'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) iSTATUS
        ON tfcmg109.t$stpp = iSTATUS.CODE

 LEFT JOIN ( SELECT l.t$desc DESCR_TIPO_ACONSELHAMENTO,
                    d.t$cnst
               FROM baandb.tttadv401000 d,
                    baandb.tttadv140000 l
              WHERE d.t$cpac = 'tf'
                AND d.t$cdom = 'cmg.tadv'
                AND l.t$clan = 'p'
                AND l.t$cpac = 'tf'
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
                                            and l1.t$cpac = l.t$cpac ) ) ACONSELHAMENTO
        ON ACONSELHAMENTO.t$cnst = tfcmg101.t$tadv

WHERE NVL(tfacp200.t$docn, 0) = 0
  AND tfcmg101.t$plan BETWEEN :DataPagamentoDe AND :DataPagamentoAte
  AND ((tfcmg101.t$bank = :Banco) or (:Banco = '000'))
  AND ((tfcmg011.t$agcd$l = :Agencia) or (:Agencia = '0000'))
  AND ((tfcmg001.t$bano = :Conta) or (:Conta = '00000'))
  AND tfcmg101.t$mopa$d = (CASE WHEN :CodModal = 0 THEN tfcmg101.t$mopa$d ELSE :CodModal END)
  AND tfcmg101.t$paym = (CASE WHEN :TipoPagto = 'Todos' THEN tfcmg101.t$paym ELSE :TipoPagto END)
  AND tfcmg101.t$tadv IN (:TipoAconselhamento)
  AND tfcmg109.t$stpp IN (:Situacao)
  AND CASE WHEN tfcmg101.t$tadv = 5           --Pagamento Adiantado
             THEN CASE WHEN tfcmg103.t$paid = 1  
                         THEN 'Pago'  
                       ELSE   'Criado'  
                  END  
               WHEN tfcmg101.t$tadv IN (3, 4) --Nota de Credito de Venda (Livre, Não Aplicável)
             THEN CASE WHEN TRIM(StatusCreditoVenda.DESC_STATUSCREDITOVENDA) = 'Parciamente pago'
                          THEN 'Parcialmente pago'
                        ELSE StatusCreditoVenda.DESC_STATUSCREDITOVENDA
                   END
           ELSE iPrgStat.DESCR
      END IN (:StatusPagto)
  AND NVL(CASE WHEN tflcb230.t$send$d = 0
                 THEN tflcb230.t$stat$d
               ELSE   tflcb230.t$send$d
           END, 0) IN (:StatusArquivo)
  AND ((:LoteTodos = 1) OR ((tfcmg101.t$btno IN (:Lote)) And :LoteTodos = 0))
  
  

=

" SELECT tfcmg101.t$btno                                     NUME_LOTE,  " &
"        ABS(LOTE.VALO_LOTE)                                 VALO_LOTE,  " &
"  " &
"        tfcmg101.t$ninv                                     NUME_TITULO,  " &
"        NVL(tfacp200.t$docn$l, tfacr200.t$docn$l)           NUME_NF,  " &
"        tfcmg101.t$ttyp         CODE_TRANSAC,  " &
"        tfcmg101.t$dued$l       DATA_VENC,  " &
"        regexp_replace(tccom130.t$fovn$l, '[^0-9]', '')     CNPJ_FORN,  " &
"        Trim(tccom100.t$nama)                               NOME_FORN,  " &
"  " &
"        CASE WHEN tfcmg101.t$tadv IN (3, 4)  " &
"               THEN (tfcmg101.t$amnt - tfcmg101.t$ramn$l) * (-1)  " &
"             ELSE   (tfcmg101.t$amnt - tfcmg101.t$ramn$l)  " &
"        END                                                 VALO_PAGA,  " &
"  " &
"        CASE WHEN tfcmg101.t$tadv IN (3, 4)  " &
"               THEN (tfcmg101.t$amnt$l) * (-1)  " &
"             ELSE    tfcmg101.t$amnt$l  " &
"        END                                                 VALO_BRUTO,  " &
"  " &
"        tfcmg101.t$post                                     CODE_LIQUID,  " &
"        tfcmg101.t$paym                                     CODE_METPGTO,  " &
"  " &
"        CASE WHEN tfcmg003.t$typp = 2  " &
"               THEN 1  " &
"             ELSE   2  " &
"         END                                                CODE_TIPOPGTO,  " &
"  " &
"        tfcmg101.t$bank                                     NUME_BANCO,  " &
"        tfcmg011.t$agcd$l                                   CODE_AGENCIA,  " &
"        tfcmg001.t$bano                                     CODE_CONTA,  " &
"        tfcmg101.t$mopa$d                                   CODE_MODAL,  " &
"        iTABLE.                                             DESC_MODAL,  " &
"        tfcmg101.t$plan                                     DATA_PAGAM,  " &
"        tfcmg109.t$stpp                                     CODE_STATUS,  " &
"        iSTATUS.DESCR                                       DESCR_STATUS,  " &
"        tfcmg101.t$tadv                                     CODE_TIPO_ACONSELHAMENTO,  " &
"  " &
"        ACONSELHAMENTO.                                     DESCR_TIPO_ACONSELHAMENTO,  " &
"  " &
"        CASE WHEN tfcmg101.t$tadv = 5  " &
"               THEN CASE WHEN tfcmg103.t$paid = 1  " &
"                           THEN 5  " &
"                         ELSE   99  " &
"                     END  " &
"             WHEN tfcmg101.t$tadv = 4  " &
"               THEN tfacr201.t$rpst$l  " &
"             ELSE   NVL(tfacp201.t$pyst$l, tfcmg104.t$stst)  " &
"        END                                                 CODE_STAT_PRG,  " &
"  " &
"        CASE WHEN tfcmg101.t$tadv = 5  " &
"               THEN CASE WHEN tfcmg103.t$paid = 1  " &
"                           THEN 'Pago'  " &
"                         ELSE   'Criado'  " &
"                    END  " &
"             WHEN tfcmg101.t$tadv in (3,4)  " &
"               THEN StatusCreditoVenda.DESC_STATUSCREDITOVENDA  " &
"             ELSE iPrgStat.DESCR  " &
"        END                                                 DESCR_STAT_PRG,  " &
"  " &
"        CASE WHEN tflcb230.t$send$d = 0  " &
"               THEN tflcb230.t$stat$d  " &
"             ELSE tflcb230.t$send$d  " &
"        END                                                 CODE_STAT_ARQ,  " &
"  " &
"        iStatArq.DESCR                                      DESCR_STAT_ARQ  " &
"  " &
" FROM       baandb.ttfcmg101" + Parameters!Compania.Value +  "   tfcmg101  " &
"  " &
" INNER JOIN baandb.ttccom100" + Parameters!Compania.Value +  "   tccom100  " &
"         ON tccom100.T$BPID = tfcmg101.t$ifbp  " &
"  " &
" INNER JOIN baandb.ttccom130" + Parameters!Compania.Value +  "   tccom130  " &
"         ON tccom130.t$cadr = tccom100.t$cadr  " &
"  " &
" INNER JOIN ( SELECT SUM(t.t$amnt) VALO_LOTE,  " &
"                     t.t$ninv,  " &
"                     t.t$ttyp,  " &
"                     t.t$btno  " &
"                FROM baandb.ttfcmg101" + Parameters!Compania.Value +  "  t  " &
"            GROUP BY t.t$ninv,  " &
"                     t.t$ttyp,  " &
"                     t.t$btno ) LOTE  " &
"         ON LOTE.t$ninv = tfcmg101.t$ninv  " &
"        AND LOTE.t$ttyp = tfcmg101.t$ttyp  " &
"        AND LOTE.t$btno = tfcmg101.t$btno  " &
"  " &
" INNER JOIN baandb.ttfcmg109" + Parameters!Compania.Value +  "   tfcmg109  " &
"         ON tfcmg109.t$btno = tfcmg101.t$btno  " &
"  " &
" INNER JOIN baandb.ttfcmg003301  tfcmg003  " &
"         ON tfcmg003.t$paym = tfcmg101.t$paym  " &
"  " &
"  LEFT JOIN baandb.ttfacp201" + Parameters!Compania.Value +  "  tfacp201  " &
"         ON tfacp201.t$ttyp = tfcmg101.t$ttyp  " &
"        AND tfacp201.t$ninv = tfcmg101.t$ninv  " &
"        AND tfacp201.t$schn = tfcmg101.t$schn  " &
"  " &
"  LEFT JOIN baandb.ttfacp200" + Parameters!Compania.Value +  "  tfacp200  " &
"         ON tfacp200.t$ttyp = tfacp201.t$ttyp  " &
"        AND tfacp200.t$ninv = tfacp201.t$ninv  " &
"  " &
"   LEFT JOIN baandb.ttfacr200301     tfacr200  " &
"          ON tfacr200.t$ttyp = tfcmg101.t$ttyp  " &
"         AND tfacr200.t$ninv = tfcmg101.t$ninv  " &
"         AND tfacr200.t$line = 0  " &
"         AND tfacr200.t$lino = 0  " &
"  " &
"  LEFT JOIN baandb.ttfcmg103" + Parameters!Compania.Value +  "  tfcmg103  " &
"         ON tfcmg103.t$btno = tfcmg101.t$btno  " &
"        AND tfcmg103.t$ptbp = tfcmg101.t$ptbp  " &
"        AND tfcmg103.t$docn = tfcmg101.t$pdoc  " &
"        AND tfcmg103.t$ttyp = tfcmg101.t$ptyp  " &
"  " &
"  LEFT JOIN baandb.ttfcmg001" + Parameters!Compania.Value +  "  tfcmg001  " &
"         ON tfcmg001.t$bank = tfcmg101.t$bank  " &
"  " &
"  LEFT JOIN baandb.ttfcmg011" + Parameters!Compania.Value +  "  tfcmg011  " &
"         ON tfcmg011.t$bank = tfcmg001.t$brch  " &
"  " &
"  LEFT JOIN baandb.ttfacp201" + Parameters!Compania.Value +  "  tfacp201  " &
"         ON tfacp201.t$ttyp = tfcmg101.t$ttyp  " &
"        AND tfacp201.t$ninv = tfcmg101.t$ninv  " &
"        AND tfacp201.t$schn = tfcmg101.t$schn  " &
"  " &
"  LEFT JOIN baandb.ttfacr201" + Parameters!Compania.Value +  "  tfacr201  " &
"         ON tfacr201.t$ttyp = tfcmg101.t$ttyp  " &
"        AND tfacr201.t$ninv = tfcmg101.t$ninv  " &
"        AND tfacr201.t$recd = tfcmg101.t$dued$l  " &
"        AND tfacr201.t$schn = tfcmg101.t$schn  " &
"  " &
"  LEFT JOIN ( select distinct  " &
"                     iDOMAIN.t$cnst CODE_STATUSCREDITOVENDA,  " &
"                     iLABEL.t$desc  DESC_STATUSCREDITOVENDA  " &
"                from baandb.tttadv401000 iDOMAIN,  " &
"                     baandb.tttadv140000 iLABEL  " &
"               where iDOMAIN.t$cpac = 'tf'  " &
"                 and iDOMAIN.t$cdom = 'acr.strp.l'  " &
"                 and iLABEL.t$clan = 'p'  " &
"                 and iLABEL.t$cpac = 'tf'  " &
"                 and iLABEL.t$clab = iDOMAIN.t$za_clab  " &
"                 and rpad(iDOMAIN.t$vers,4) ||  " &
"                     rpad(iDOMAIN.t$rele,2) ||  " &
"                     rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                           rpad(l1.t$rele,2) ||  " &
"                                                           rpad(l1.t$cust,4))  " &
"                                                  from baandb.tttadv401000 l1  " &
"                                                 where l1.t$cpac = iDOMAIN.t$cpac  " &
"                                                   and l1.t$cdom = iDOMAIN.t$cdom )  " &
"                 and rpad(iLABEL.t$vers,4) ||  " &
"                     rpad(iLABEL.t$rele,2) ||  " &
"                     rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                          rpad(l1.t$rele,2) ||  " &
"                                                          rpad(l1.t$cust,4))  " &
"                                                 from baandb.tttadv140000 l1  " &
"                                                where l1.t$clab = iLABEL.t$clab  " &
"                                                  and l1.t$clan = iLABEL.t$clan  " &
"                                                  and l1.t$cpac = iLABEL.t$cpac ) ) StatusCreditoVenda  " &
"         ON tfacr201.t$rpst$l = StatusCreditoVenda.CODE_STATUSCREDITOVENDA  " &
"  " &
"  LEFT JOIN baandb.ttfcmg104" + Parameters!Compania.Value +  "  tfcmg104  " &
"         ON tfcmg104.t$orno = tfcmg101.t$ninv  " &
"        AND tfcmg104.t$ifbp = tfcmg101.t$ifbp  " &
"  " &
"  LEFT JOIN ( select sum(a.t$amti) JUROS,  " &
"                     a.t$ttyp,  " &
"                     a.t$ninv  " &
"                from baandb.ttfacp200" + Parameters!Compania.Value +  "   a  " &
"               where a.t$tpay = 5  " &
"            group by a.t$ttyp, a.t$ninv )  ACP200  " &
"         ON ACP200.t$ttyp = tfcmg101.t$ttyp  " &
"        AND ACP200.t$ninv = tfcmg101.t$ninv  " &
"  " &
"  LEFT JOIN ( SELECT d.t$cnst CODE,  " &
"                     l.t$desc DESCR  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'acp.pyst.l'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac )  " &
"  " &
"               UNION  " &
"  " &
"              SELECT d.t$cnst*10 CODE,  " &
"                     l.t$desc DESCR  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'cmg.stst'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) iPrgStat  " &
"         ON iPrgStat.CODE = nvl(tfacp201.t$pyst$l, tfcmg104.t$stst*10)  " &
"  " &
"  LEFT JOIN ( SELECT a.t$ttyp$d,  " &
"                     a.t$ninv$d,  " &
"                     a.t$ptyp$d,  " &
"                     a.t$docn$d,  " &
"                     max(a.t$stat$d) t$stat$d,  " &
"                     max(a.t$send$d) t$send$d  " &
"                FROM baandb.ttflcb230" + Parameters!Compania.Value +  "  a  " &
"               WHERE a.t$sern$d = ( select max(b.t$sern$d)  " &
"                                      from baandb.ttflcb230" + Parameters!Compania.Value +  "  b  " &
"                                     where b.t$ttyp$d = a.t$ttyp$d  " &
"                                       and b.t$ninv$d = a.t$ninv$d  " &
"                                       and b.t$ptyp$d = a.t$ptyp$d  " &
"                                       and b.t$docn$d = a.t$docn$d )  " &
"            GROUP BY a.t$ttyp$d,  " &
"                     a.t$ninv$d,  " &
"                     a.t$ptyp$d,  " &
"                     a.t$docn$d ) tflcb230  " &
"         ON tflcb230.t$ttyp$d = tfcmg101.t$ttyp  " &
"        AND tflcb230.t$ninv$d = tfcmg101.t$ninv  " &
"        AND tflcb230.t$ptyp$d = tfcmg101.t$ptyp  " &
"        AND tflcb230.t$docn$d = tfcmg101.t$pdoc  " &
"  " &
"  LEFT JOIN ( SELECT 0                 CODE,  " &
"                     'Não vinculado'   DESCR  " &
"                FROM Dual  " &
"  " &
"               UNION  " &
"  " &
"              SELECT d.t$cnst CODE,  " &
"                     l.t$desc DESCR  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'cmg.stat.l'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) iStatArq  " &
"         ON iStatArq.CODE = NVL(CASE WHEN tflcb230.t$send$d = 0  " &
"                                       THEN tflcb230.t$stat$d  " &
"                                     ELSE   tflcb230.t$send$d  " &
"                                 END, 0)  " &
"  " &
" LEFT JOIN ( SELECT iDOMAIN.t$cnst CODE_MODAL,  " &
"                    iLABEL.t$desc DESC_MODAL  " &
"               FROM baandb.tttadv401000 iDOMAIN,  " &
"                    baandb.tttadv140000 iLABEL  " &
"              WHERE iDOMAIN.t$cpac = 'tf'  " &
"                AND iDOMAIN.t$cdom = 'cmg.mopa.d'  " &
"                AND iLABEL.t$clan = 'p'  " &
"                AND iLABEL.t$cpac = 'tf'  " &
"                AND iLABEL.t$clab = iDOMAIN.t$za_clab  " &
"                AND rpad(iDOMAIN.t$vers,4) ||  " &
"                    rpad(iDOMAIN.t$rele,2) ||  " &
"                    rpad(iDOMAIN.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                          rpad(l1.t$rele,2) ||  " &
"                                                          rpad(l1.t$cust,4))  " &
"                                                 from baandb.tttadv401000 l1  " &
"                                                where l1.t$cpac = iDOMAIN.t$cpac  " &
"                                                  and l1.t$cdom = iDOMAIN.t$cdom )  " &
"                AND rpad(iLABEL.t$vers,4) ||  " &
"                    rpad(iLABEL.t$rele,2) ||  " &
"                    rpad(iLABEL.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                         rpad(l1.t$rele,2) ||  " &
"                                                         rpad(l1.t$cust,4))  " &
"                                                from baandb.tttadv140000 l1  " &
"                                               where l1.t$clab = iLABEL.t$clab  " &
"                                                 and l1.t$clan = iLABEL.t$clan  " &
"                                                 and l1.t$cpac = iLABEL.t$cpac ) ) iTABLE  " &
"         ON tfcmg101.t$mopa$d = iTABLE.CODE_MODAL  " &
"  " &
"  LEFT JOIN ( SELECT d.t$cnst CODE,  " &
"                     l.t$desc DESCR,  " &
"                     'CAP' CD_MODULO  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'cmg.stpp'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) iSTATUS  " &
"         ON tfcmg109.t$stpp = iSTATUS.CODE  " &
"  " &
"  LEFT JOIN ( SELECT l.t$desc DESCR_TIPO_ACONSELHAMENTO,  " &
"                     d.t$cnst  " &
"                FROM baandb.tttadv401000 d,  " &
"                     baandb.tttadv140000 l  " &
"               WHERE d.t$cpac = 'tf'  " &
"                 AND d.t$cdom = 'cmg.tadv'  " &
"                 AND l.t$clan = 'p'  " &
"                 AND l.t$cpac = 'tf'  " &
"                 AND l.t$clab = d.t$za_clab  " &
"                 AND rpad(d.t$vers,4) ||  " &
"                     rpad(d.t$rele,2) ||  " &
"                     rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv401000 l1  " &
"                                           where l1.t$cpac = d.t$cpac  " &
"                                             and l1.t$cdom = d.t$cdom )  " &
"                 AND rpad(l.t$vers,4) ||  " &
"                     rpad(l.t$rele,2) ||  " &
"                     rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||  " &
"                                                     rpad(l1.t$rele,2) ||  " &
"                                                     rpad(l1.t$cust,4))  " &
"                                            from baandb.tttadv140000 l1  " &
"                                           where l1.t$clab = l.t$clab  " &
"                                             and l1.t$clan = l.t$clan  " &
"                                             and l1.t$cpac = l.t$cpac ) ) ACONSELHAMENTO  " &
"         ON ACONSELHAMENTO.t$cnst = tfcmg101.t$tadv  " &
"  " &
" WHERE NVL(tfacp200.t$docn, 0) = 0  " &
"   AND tfcmg101.t$plan BETWEEN :DataPagamentoDe AND :DataPagamentoAte  " &
"   AND ((tfcmg101.t$bank = '" + Mid(Parameters!Banco.Value,4,3) + "') or ('" + Mid(Parameters!Banco.Value,4,3) + "' = '000'))  " &
"   AND ((tfcmg011.t$agcd$l = '" + Mid(Parameters!Agencia.Value,7,4) + "') or ('" + Mid(Parameters!Agencia.Value,7,4) + "' = '0000'))  " &
"   AND ((tfcmg001.t$bano = '" + Mid(Parameters!Conta.Value,11,5) + "') or ('" + Mid(Parameters!Conta.Value,12,5) + "' = '00000'))  " &
"   AND tfcmg101.t$mopa$d = (CASE WHEN :CodModal = 0 THEN tfcmg101.t$mopa$d ELSE :CodModal END)  " &
"   AND tfcmg101.t$paym = (CASE WHEN :TipoPagto = 'Todos' THEN tfcmg101.t$paym ELSE :TipoPagto END)  " &
"   AND tfcmg101.t$tadv IN (" + JOIN(Parameters!TipoAconselhamento.Value, ", ") + ") " &
"   AND tfcmg109.t$stpp IN (" + JOIN(Parameters!Situacao.Value, ", ") + ") " &
"   AND CASE WHEN tfcmg101.t$tadv = 5 " &  
"              THEN CASE WHEN tfcmg103.t$paid = 1 " &  
"                          THEN 'Pago' " &  
"                        ELSE   'Criado' " &  
"                   END " &  
"                WHEN tfcmg101.t$tadv IN (3,4) " & 
"              THEN CASE WHEN TRIM(StatusCreditoVenda.DESC_STATUSCREDITOVENDA) = 'Parciamente pago' " &
"              				THEN 'Parcialmente pago' " &
"						 ELSE StatusCreditoVenda.DESC_STATUSCREDITOVENDA " &
"                   END " &
"            ELSE iPrgStat.DESCR " &
"       END IN (" + Replace(("'" + JOIN(Parameters!StatusPagto.Value, "',") + "'"),",",",'") + ") " &
"   AND NVL(CASE WHEN tflcb230.t$send$d = 0  " &
"                  THEN tflcb230.t$stat$d  " &
"                ELSE   tflcb230.t$send$d  " &
"            END, 0) IN (" + JOIN(Parameters!StatusArquivo.Value, ", ") + ") " &
"   AND ( (tfcmg101.t$btno IN  "&
"         ( " + IIF(Trim(Parameters!Lote.Value) = "", "''", "'" + Replace(Replace(Parameters!Lote.Value, " ", ""), ",", "','") + "'")  + " )  "&
"           AND (" + IIF(Parameters!Lote.Value Is Nothing, "1", "0") + " = 0))  " &
"            OR (" + IIF(Parameters!Lote.Value Is Nothing, "1", "0") + " = 1) ) "
