select
  znsls402.t$pecl$c       PEDIDO_NIKE,
  CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,
    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
      AT time zone 'America/Sao_Paulo') AS DATE)
                          DATA_SOLICITACAO,
  SYSDATE                 DATA_ARQUIVO,
  znsls400.T$nomf$c       NOME_CLIENTE,
  znsls402.t$logr$c       ENDERECO,
  znsls402.t$nume$c       NUMERO,
  znsls402.t$CCEP$C       CEP,
  znsls402.t$cida$c       CIDADE,
  znsls402.t$couf$c       UF,
  znsls402.t$bair$c       BAIRRO,
  znsls401.t$te1e$c       TELEFONE,
  znsls401.t$emae$c       EMAIL,
  znsls400.t$iclf$c       CPF,
  case when znsls402.t$idct$c = 0
         then NULL
       else znsls402.t$idct$c ||
            case when Trim(znsls402.t$dgct$c) is not null
                   then '-'           ||
                        znsls402.t$dgct$c
                 else NULL
            end
  end                     CONTA_BANCARIA,
  case when znsls402.t$idag$c = 0
         then NULL
       else znsls402.t$idag$c ||
            case when Trim(znsls402.t$dgag$c) is not null
                   then '-'           ||
                        znsls402.t$dgag$c
                 else NULL
            end
  end                     AGENCIA_BANCARIA,
  tfcmg011.t$desc         DESC_BANCO,
  znsls402.t$idbc$c       COD_BANCO,
  znsls401.t$lass$c       TIPO_CANCELAMENTO,
  ( select znsls400.t$dtem$c
      from baandb.tznsls401601 sls401
     where sls401.t$ncia$c = znsls400.t$ncia$c
       and sls401.t$uneg$c = znsls400.t$uneg$c
       and sls401.t$pecl$c = znsls400.t$pecl$c
       and sls401.t$idor$c = 'LJ'
  group by znsls400.t$pecl$c )
                          DATA_VENDA,
  znsls402.t$slst$c       VALOR_VENDA,
  ABS(znsls402.t$vlmr$c)  VALOR_ESTORNO,
  znsls401.t$lmot$c       MOTIVO,
  ABS(znsls401.t$qtve$c)  QTDE,
  CASE WHEN znsls409.t$dved$c = 1 OR
            znsls409.t$lbrd$c = 1 OR
            znsls410.PT_CONTR IN ('CAN', 'AES','WMS')
         THEN 'Sim'
       ELSE   'Não'
  END                     LIBERADO

FROM       baandb.tznsls402601 znsls402

 LEFT JOIN baandb.tznsls400601 znsls400
        ON znsls400.t$ncia$c = znsls402.t$ncia$c
       AND znsls400.t$uneg$c = znsls402.t$uneg$c
       AND znsls400.t$pecl$c = znsls402.t$pecl$c
       AND znsls400.t$sqpd$c = znsls402.t$sqpd$c

INNER JOIN ( select sls401.t$te1e$c,
                    sls401.t$emae$c,
                    sls401.t$lmot$c,
                    sls401.t$lass$c,
                    SUM(sls401.t$qtve$c) t$qtve$c,
                    sls401.t$idor$c,
                    sls401.t$ncia$c,
                    sls401.t$uneg$c,
                    sls401.t$pecl$c,
                    sls401.t$sqpd$c,
                    sls401.t$orno$c
               from baandb.tznsls401601 sls401
              where sls401.t$qtve$c < 0
                and sls401.t$idor$c = 'TD'
           group by sls401.t$te1e$c,
                    sls401.t$emae$c,
                    sls401.t$lmot$c,
                    sls401.t$lass$c,
                    sls401.t$idor$c,
                    sls401.t$ncia$c,
                    sls401.t$uneg$c,
                    sls401.t$pecl$c,
                    sls401.t$sqpd$c,
                    sls401.t$orno$c ) znsls401
        on znsls401.t$ncia$c = znsls400.t$ncia$c
       and znsls401.t$uneg$c = znsls400.t$uneg$c
       and znsls401.t$pecl$c = znsls400.t$pecl$c
       and znsls401.t$sqpd$c = znsls400.t$sqpd$c

 LEFT JOIN baandb.ttfcmg011601 tfcmg011
        ON to_char(tfcmg011.t$baoc$l) = to_char(znsls402.t$idbc$c)
       AND to_char(tfcmg011.t$agcd$l) = to_char(znsls402.t$idag$c)

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$entr$c,
                    a.t$dorn$c,
                    a.t$dved$c,
                    a.t$lbrd$c
               from baandb.tznsls409601 a ) znsls409
        ON znsls409.t$ncia$c = znsls402.t$ncia$c
       AND znsls409.t$uneg$c = znsls402.t$uneg$c
       AND znsls409.t$pecl$c = znsls402.t$pecl$c
       AND znsls409.t$sqpd$c = znsls402.t$sqpd$c
       AND znsls409.t$dorn$c = znsls401.t$orno$c

 LEFT JOIN ( select a.t$ncia$c,
                    a.t$uneg$c,
                    a.t$pecl$c,
                    a.t$sqpd$c,
                    a.t$idpo$c
               from baandb.tznsls400601 a ) znsls400_LJ
        ON znsls400_LJ.t$ncia$c = znsls402.t$ncia$c
       AND znsls400_LJ.t$uneg$c = znsls402.t$uneg$c
       AND znsls400_LJ.t$pecl$c = znsls402.t$pecl$c
       AND znsls400_LJ.t$idpo$c = 'LJ'

 LEFT JOIN ( select znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c,
                    MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR
               from baandb.tznsls410601 znsls410
           group by znsls410.t$ncia$c,
                    znsls410.t$uneg$c,
                    znsls410.t$pecl$c,
                    znsls410.t$sqpd$c ) znsls410
        ON znsls410.t$ncia$c = znsls402.t$ncia$c
       AND znsls410.t$uneg$c = znsls402.t$uneg$c
       AND znsls410.t$pecl$c = znsls402.t$pecl$c
       AND znsls410.t$sqpd$c = znsls400_LJ.t$sqpd$c

     WHERE znsls402.t$vlmr$c < 0
       AND znsls402.t$idmp$c not in (1, 4) --cartao de credito e vale
       AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,
                   'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') AS DATE))
           Between :DataSolicitacaoDe
               And :DataSolicitacaoAte
       AND (('Todos' = '+ Parameters!Liberado.Value + ') OR
            ( CASE WHEN znsls409.t$dved$c = 1 OR
                        znsls409.t$lbrd$c = 1 OR
                        znsls410.PT_CONTR IN ('CAN', 'AES','WMS')
                     THEN 'Sim'
                   ELSE   'Não'
              END = '+ Parameters!Liberado.Value + ') ) &
  ORDER BY PEDIDO_NIKE  
  
  
  
=
  
" select  " &
"   znsls402.t$pecl$c       PEDIDO_NIKE,  " &
"   CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,  " &
"     'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"       AT time zone 'America/Sao_Paulo') AS DATE)  " &
"                           DATA_SOLICITACAO,  " &
"   SYSDATE                 DATA_ARQUIVO,  " &
"   znsls400.T$nomf$c       NOME_CLIENTE,  " &
"   znsls402.t$logr$c       ENDERECO,  " &
"   znsls402.t$nume$c       NUMERO,  " &
"   znsls402.t$CCEP$C       CEP,  " &
"   znsls402.t$cida$c       CIDADE,  " &
"   znsls402.t$couf$c       UF,  " &
"   znsls402.t$bair$c       BAIRRO,  " &
"   znsls401.t$te1e$c       TELEFONE,  " &
"   znsls401.t$emae$c       EMAIL,  " &
"   znsls400.t$iclf$c       CPF,  " &
"   case when znsls402.t$idct$c = 0  " &
"          then NULL  " &
"        else znsls402.t$idct$c ||  " &
"             case when Trim(znsls402.t$dgct$c) is not null  " &
"                    then '-'           ||  " &
"                         znsls402.t$dgct$c  " &
"                  else NULL  " &
"             end  " &
"   end                     CONTA_BANCARIA,  " &
"   case when znsls402.t$idag$c = 0  " &
"          then NULL  " &
"        else znsls402.t$idag$c ||  " &
"             case when Trim(znsls402.t$dgag$c) is not null  " &
"                    then '-'           ||  " &
"                         znsls402.t$dgag$c  " &
"                  else NULL  " &
"             end  " &
"   end                     AGENCIA_BANCARIA,  " &
"   tfcmg011.t$desc         DESC_BANCO,  " &
"   znsls402.t$idbc$c       COD_BANCO,  " &
"   znsls401.t$lass$c       TIPO_CANCELAMENTO,  " &
"   ( select znsls400.t$dtem$c  " &
"       from baandb.tznsls401" + Parameters!Compania.Value + " sls401  " &
"      where sls401.t$ncia$c = znsls400.t$ncia$c  " &
"        and sls401.t$uneg$c = znsls400.t$uneg$c  " &
"        and sls401.t$pecl$c = znsls400.t$pecl$c  " &
"        and sls401.t$idor$c = 'LJ'  " &
"   group by znsls400.t$pecl$c )  " &
"                           DATA_VENDA,  " &
"   znsls402.t$slst$c       VALOR_VENDA,  " &
"   ABS(znsls402.t$vlmr$c)  VALOR_ESTORNO,  " &
"   znsls401.t$lmot$c       MOTIVO,  " &
"   ABS(znsls401.t$qtve$c)  QTDE,  " &
"   CASE WHEN znsls409.t$dved$c = 1 OR  " &
"             znsls409.t$lbrd$c = 1 OR  " &
"             znsls410.PT_CONTR IN ('CAN', 'AES','WMS')  " &
"          THEN 'Sim'  " &
"        ELSE   'Não'  " &
"   END                     LIBERADO  " &
"  " &
" FROM       baandb.tznsls402" + Parameters!Compania.Value + " znsls402  " &
"  " &
"  LEFT JOIN baandb.tznsls400" + Parameters!Compania.Value + " znsls400  " &
"         ON znsls400.t$ncia$c = znsls402.t$ncia$c  " &
"        AND znsls400.t$uneg$c = znsls402.t$uneg$c  " &
"        AND znsls400.t$pecl$c = znsls402.t$pecl$c  " &
"        AND znsls400.t$sqpd$c = znsls402.t$sqpd$c  " &
"  " &
" INNER JOIN ( select sls401.t$te1e$c,  " &
"                     sls401.t$emae$c,  " &
"                     sls401.t$lmot$c,  " &
"                     sls401.t$lass$c,  " &
"                     SUM(sls401.t$qtve$c) t$qtve$c,  " &
"                     sls401.t$idor$c,  " &
"                     sls401.t$ncia$c,  " &
"                     sls401.t$uneg$c,  " &
"                     sls401.t$pecl$c,  " &
"                     sls401.t$sqpd$c,  " &
"                     sls401.t$orno$c  " &
"                from baandb.tznsls401" + Parameters!Compania.Value + " sls401  " &
"               where sls401.t$qtve$c < 0  " &
"                 and sls401.t$idor$c = 'TD'  " &
"            group by sls401.t$te1e$c,  " &
"                     sls401.t$emae$c,  " &
"                     sls401.t$lmot$c,  " &
"                     sls401.t$lass$c,  " &
"                     sls401.t$idor$c,  " &
"                     sls401.t$ncia$c,  " &
"                     sls401.t$uneg$c,  " &
"                     sls401.t$pecl$c,  " &
"                     sls401.t$sqpd$c,  " &
"                     sls401.t$orno$c ) znsls401  " &
"         on znsls401.t$ncia$c = znsls400.t$ncia$c  " &
"        and znsls401.t$uneg$c = znsls400.t$uneg$c  " &
"        and znsls401.t$pecl$c = znsls400.t$pecl$c  " &
"        and znsls401.t$sqpd$c = znsls400.t$sqpd$c  " &
"  " &
"  LEFT JOIN baandb.ttfcmg011" + Parameters!Compania.Value + " tfcmg011  " &
"         ON to_char(tfcmg011.t$baoc$l) = to_char(znsls402.t$idbc$c)  " &
"        AND to_char(tfcmg011.t$agcd$l) = to_char(znsls402.t$idag$c)  " &
"  " &
"  LEFT JOIN ( select a.t$ncia$c,  " &
"                     a.t$uneg$c,  " &
"                     a.t$pecl$c,  " &
"                     a.t$sqpd$c,  " &
"                     a.t$entr$c,  " &
"                     a.t$dorn$c,  " &
"                     a.t$dved$c,  " &
"                     a.t$lbrd$c  " &
"                from baandb.tznsls409" + Parameters!Compania.Value + " a ) znsls409  " &
"         ON znsls409.t$ncia$c = znsls402.t$ncia$c  " &
"        AND znsls409.t$uneg$c = znsls402.t$uneg$c  " &
"        AND znsls409.t$pecl$c = znsls402.t$pecl$c  " &
"        AND znsls409.t$sqpd$c = znsls402.t$sqpd$c  " &
"        AND znsls409.t$dorn$c = znsls401.t$orno$c  " &
"  " &
"  LEFT JOIN ( select a.t$ncia$c,  " &
"                     a.t$uneg$c,  " &
"                     a.t$pecl$c,  " &
"                     a.t$sqpd$c,  " &
"                     a.t$idpo$c  " &
"                from baandb.tznsls400" + Parameters!Compania.Value + " a ) znsls400_LJ  " &
"         ON znsls400_LJ.t$ncia$c = znsls402.t$ncia$c  " &
"        AND znsls400_LJ.t$uneg$c = znsls402.t$uneg$c  " &
"        AND znsls400_LJ.t$pecl$c = znsls402.t$pecl$c  " &
"        AND znsls400_LJ.t$idpo$c = 'LJ'  " &
"  " &
"  LEFT JOIN ( select znsls410.t$ncia$c,  " &
"                     znsls410.t$uneg$c,  " &
"                     znsls410.t$pecl$c,  " &
"                     znsls410.t$sqpd$c,  " &
"                     MAX(znsls410.t$poco$c) KEEP (DENSE_RANK LAST ORDER BY znsls410.T$DTOC$C,  znsls410.T$SEQN$C) PT_CONTR  " &
"                from baandb.tznsls410" + Parameters!Compania.Value + " znsls410  " &
"            group by znsls410.t$ncia$c,  " &
"                     znsls410.t$uneg$c,  " &
"                     znsls410.t$pecl$c,  " &
"                     znsls410.t$sqpd$c ) znsls410  " &
"         ON znsls410.t$ncia$c = znsls402.t$ncia$c  " &
"        AND znsls410.t$uneg$c = znsls402.t$uneg$c  " &
"        AND znsls410.t$pecl$c = znsls402.t$pecl$c  " &
"        AND znsls410.t$sqpd$c = znsls400_LJ.t$sqpd$c  " &
"  " &
"      WHERE znsls402.t$vlmr$c < 0  " &
"        AND znsls402.t$idmp$c not in (1, 4)  " &
"        AND Trunc(CAST((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znsls400.t$dtem$c,  " &
"                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')  " &
"                      AT time zone 'America/Sao_Paulo') AS DATE))  " &
"            Between :DataSolicitacaoDe  " &
"                And :DataSolicitacaoAte  " &
"        AND (('Todos' = '" + Parameters!Liberado.Value + "') OR  " &
"             ( CASE WHEN znsls409.t$dved$c = 1 OR  " &
"                         znsls409.t$lbrd$c = 1 OR  " &
"                         znsls410.PT_CONTR IN ('CAN', 'AES','WMS')  " &
"                      THEN 'Sim'  " &
"                    ELSE   'Não'  " &
"               END = '" + Parameters!Liberado.Value + "') ) " &
"   ORDER BY PEDIDO_NIKE  "