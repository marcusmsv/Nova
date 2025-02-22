select  distinct
        OPERACAO.DESCR                                OPERACAO,
        znnfe011.t$fire$c                             REF_FISCAL,
        case when znnfe011.t$oper$c = 1 then
             (select a.t$fdtc$l
              from   baandb.tcisli940301 a
              where  a.t$fire$l = znnfe011.t$fire$c)
        else
             (select a.t$fdtc$l
              from   baandb.ttdrec940301 a
              where  a.t$fire$l = znnfe011.t$fire$c)
        end                                           COD_TIPO_DOC,
        case when znnfe011.t$oper$c = 1 then
             (select b.t$dsca$l
              from   baandb.tcisli940301 a,
                     baandb.ttcmcs966301 b
              where  a.t$fire$l = znnfe011.t$fire$c
                and  b.t$fdtc$l = a.t$fdtc$l)
        else
             (select b.t$dsca$l
              from   baandb.ttdrec940301 a,
                     baandb.ttcmcs966301 b
              where  a.t$fire$l = znnfe011.t$fire$c
                and  b.t$fdtc$l = a.t$fdtc$l)
        end                                           DESCRICAO,
        case when znnfe011.t$oper$c = 1 then
             (select l.t$desc
              from   baandb.tcisli940301 a,
                     baandb.tttadv401000 d,
                     baandb.tttadv140000 l
              where  a.t$fire$l = znnfe011.t$fire$c
                and  d.t$cnst = a.t$fdty$l
                and  d.t$cpac = 'ci'
                and d.t$cdom = 'sli.tdff.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'ci'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           and l1.t$clan = l.t$clan 
                                           and l1.t$cpac = l.t$cpac))
        else
             (select l.t$desc
              from   baandb.ttdrec940301 a,
                     baandb.tttadv401000 d,
                     baandb.tttadv140000 l
              where  a.t$fire$l = znnfe011.t$fire$c
                and  d.t$cnst = a.t$rfdt$l
                and  d.t$cpac = 'td'
                and d.t$cdom = 'rec.trfd.l'
                and l.t$clan = 'p'
                and l.t$cpac = 'td'
                and l.t$clab = d.t$za_clab
                and rpad(d.t$vers,4) ||
                    rpad(d.t$rele,2) ||
                    rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           and l1.t$cdom = d.t$cdom )
                and rpad(l.t$vers,4) ||
                    rpad(l.t$rele,2) ||
                    rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                    rpad(l1.t$rele,2) ||
                                                    rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           and l1.t$clan = l.t$clan 
                                           and l1.t$cpac = l.t$cpac))
        end                                           TIPO_DOC_FISCAL,
        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 2
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_TRANSMITIDA,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 2
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_NFE_TRANSMITIDA,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 1
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_NENHUM,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 1
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_NFE_NENHUM,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 3
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_PED_CANCELAMENTO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 3
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_NFE_PED_CANCELAMENTO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 4
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_PED_ESTORNO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 4
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_NFE_PED_ESTORNO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 5
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_PROCESSADA,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 5
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_NFE_PROCESSADA,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 6
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_NFE_PED_CONSULTA,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$nfes$c = 6
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_NFE_PED_CONSULTA,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 5
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_IMPRESSO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 5
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_FATURA_IMPRESSO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 1
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_AGUARDANDO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 1
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_FATURA_AGUARDANDO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 2
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_CANCELAR,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 2
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_FATURA_CANCELAR,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 3
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_CONFIRMADO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 3
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_FATURA_CONFIRMADO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 4
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_COMPOSTO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 4
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_FATURA_COMPOSTO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 6
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_LANCADO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 6
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_FATURA_LANCADO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 101
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_FATURA_ESTORNADO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stfa$c = 101
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_FATURA_ESTORNADO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 1
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_ABERTO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 1
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_REC_FISCAL_ABERTO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 3
            and   b.t$user   = a.t$logn$c 
            and   rownum <= 1 )                      STATUS_REC_FISCAL_NAO_APROV,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 3
            and   b.t$user   = a.t$logn$c 
            and   rownum <= 1 )                      DT_STATUS_REC_FISCAL_NAO_APROV,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 4
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_APROV,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 4
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_REC_FISCAL_APROV,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 5
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_APROV_PR,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 5
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_REC_FISCAL_APROV_PR,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 6
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_ESTORNADO,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 6
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_REC_FISCAL_ESTORNADO,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 200
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_AGU_WMS,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 200
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_REC_FISCAL_AGU_WMS,

        ( select  a.t$logn$c || ' - ' || b.t$name
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 201
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      STATUS_REC_FISCAL_ENV_WMS,
        ( select  cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
                    'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
                     AT time zone 'America/Sao_Paulo') as date)
          from    baandb.tznnfe011301 a,
                  baandb.tttaad200000 b
          where   a.t$oper$c = znnfe011.t$oper$c
            and   a.t$fire$c = znnfe011.t$fire$c
            and   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(a.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date)) = 
                  trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
            and   a.t$stre$c = 201
            and   b.t$user   = a.t$logn$c
            and   rownum <= 1 )                      DT_STATUS_REC_FISCAL_ENV_WMS
          
from    baandb.tznnfe011301 znnfe011

left  join ( select 
                    l.t$desc DESCR,
                    d.t$cnst
              from baandb.tttadv401000 d,
                   baandb.tttadv140000 l
             where d.t$cpac = 'br'
               and d.t$cdom = 'fbk.topm.l'
               and l.t$clan = 'p'
               and l.t$cpac = 'br'
               and l.t$clab = d.t$za_clab
               and rpad(d.t$vers,4) ||
                   rpad(d.t$rele,2) ||
                   rpad(d.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv401000 l1 
                                         where l1.t$cpac = d.t$cpac 
                                           and l1.t$cdom = d.t$cdom )
               and rpad(l.t$vers,4) ||
                   rpad(l.t$rele,2) ||
                   rpad(l.t$cust,4) = ( select max(rpad(l1.t$vers,4) ||
                                                   rpad(l1.t$rele,2) ||
                                                   rpad(l1.t$cust,4)) 
                                          from baandb.tttadv140000 l1 
                                         where l1.t$clab = l.t$clab 
                                           and l1.t$clan = l.t$clan 
                                           and l1.t$cpac = l.t$cpac ) ) OPERACAO
        on OPERACAO.t$cnst = znnfe011.t$oper$c

where   trunc(cast((FROM_TZ(TO_TIMESTAMP(TO_CHAR(znnfe011.t$data$c,
              'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'), 'GMT')
               AT time zone 'America/Sao_Paulo') as date))
               between :DATA_OCORRENCIA_DE
                   and :DATA_OCORRENCIA_ATE
  and znnfe011.t$oper$c in (:OPERACAO)
