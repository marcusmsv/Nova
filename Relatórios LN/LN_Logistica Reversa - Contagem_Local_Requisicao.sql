	SELECT GLOBALINVCOUNTDETAIL.REQUESTNUMBER AS REQUISICAO,GLOBALINVCOUNTDETAIL.LOCATION AS LOCAL, 
		   GLOBALINVCOUNTDETAIL.NOOFCOUNTS AS CONTAGEM_SOLICITADA,GLOBALINVCOUNTDETAIL.NOOFCOUNTED AS CONTAGEM_EFETUADA, 
		  
			  CASE to_char (GLOBALINVCOUNTDETAIL.STATUS) 
				 WHEN '01' THEN 'NAO_CONTADO'
				 WHEN '02' THEN 'CONTADO'
				 WHEN '03' THEN 'EM CONTAGEM'
				 WHEN '04' THEN 'LOCAL VAZIO'
				 WHEN '05' THEN 'POSTADO'
				 WHEN '06' THEN 'CONTAGEM SUPERVISOR'
				 WHEN '07' THEN 'RECONTAR'
				 WHEN '08' THEN 'DESBLOQUEADO'
			  END             
		  AS STATUS_LOCAL,
		   CASE to_char(GLOBALINVREQUEST.SIMULATION)
			  WHEN '0' THEN 'NÃO'
			  WHEN '1' THEN 'SIM'
		   END
		  AS SIMULAÇÃO
		
	FROM  WMWHSE5.GLOBALINVCOUNTDETAIL,  WMWHSE5.GLOBALINVREQUEST
	 WHERE GLOBALINVREQUEST.REQUESTNUMBER = GLOBALINVCOUNTDETAIL.REQUESTNUMBER
