CREATE OR REPLACE FUNCTION public.importacao()
  RETURNS character varying AS
$BODY$DECLARE
--
	vEnd_date			varchar(15);
	vCont				public.imp_registros.id%TYPE;
	vPesquisadorId		public.pesquisadores.id%TYPE;
	vTrabalhoId		    public.trabalhos.id%TYPE;
	vTiposArquivosId	public.tipos_artigos.id%TYPE;
	vInstituicoesId		public.instituicoes.id%TYPE;
--
	rCursor  			RECORD;
--
BEGIN
	--	
	CREATE TEMPORARY TABLE registros_tmp(tmp1 varchar(100) NULL,
										 tmp2 varchar(100) NULL,
										 tmp3 varchar(100) NULL,		                                     
										 tmp4 varchar(100) NULL,
										 tmp5 varchar(100) NULL,
										 tmp6 varchar(100) NULL,
										 tmp7 varchar(100) NULL);
	--	
	COPY registros_tmp from 'c:/data.tsv' using delimiters '	' CSV HEADER;
	--
	FOR rCursor IN SELECT registros_tmp.tmp1,
						  registros_tmp.tmp2,
						  substr(registros_tmp.tmp3, 0, 11)::date as start_date,
						  substr(registros_tmp.tmp3, 11, 11) as end_date,
						  registros_tmp.tmp4,
						  registros_tmp.tmp5,
						  registros_tmp.tmp6::date,
						  registros_tmp.tmp7
				 FROM registros_tmp LOOP
		--
		IF rCursor.end_date = '|nill' THEN
			--
			INSERT INTO public.imp_registros(name,
											 jobs,
											 institution,
											 article_type,
											 publication_date,
											 start_date,
											 end_date)
									  VALUES(rCursor.tmp1,
											 rCursor.tmp2,
											 rCursor.tmp4,
											 rCursor.tmp5,
											 rCursor.tmp6,
											 rCursor.start_date,
								  			 null);
			--
		ELSE
			--
			INSERT INTO public.imp_registros(name,
											 jobs,
											 institution,
											 article_type,
											 publication_date,
											 start_date,
											 end_date)
									  VALUES(rCursor.tmp1,
											 rCursor.tmp2,
											 rCursor.tmp4,
											 rCursor.tmp5,
											 rCursor.tmp6,
											 rCursor.start_date,
								  		 	 rCursor.end_date::date);
			--
		END IF;
		--
	END LOOP;
	--
	FOR rCursor IN SELECT name,
						  jobs,
						  institution,
						  publication_date,
						  article_type,
						  start_date,
						  end_date
	                 FROM public.imp_registros
	                ORDER BY id LOOP
		--
		--IMPORTA PESQUISADORES
		--
		SELECT count(*)
		  INTO vCont
		  FROM public.pesquisadores
		 WHERE nome = rCursor.name;
		--
		IF vCont = 0 THEN
			--
			INSERT INTO public.pesquisadores(nome)
									  VALUES(rCursor.name);
			--
		END IF;
		--
		SELECT id
		  INTO vPesquisadorId
		  FROM public.pesquisadores
		 WHERE nome = rCursor.name;
		--
		--IMPORTA TRABALHOS
		--
		SELECT count(*)
		  INTO vCont
		  FROM public.trabalhos
		 WHERE descricao = rCursor.jobs;
		--
		IF vCont = 0 THEN
			--
			INSERT INTO public.trabalhos(descricao)
								  VALUES(rCursor.jobs);
			--
		END IF;
		--
		SELECT id
		  INTO vTrabalhoId
		  FROM public.trabalhos
		 WHERE descricao = rCursor.jobs;
		--
		--IMPORTA INSTITUICOES
		--
		SELECT count(*)
		  INTO vCont
		  FROM public.instituicoes
		 WHERE descricao = rCursor.institution;
		--
		IF vCont = 0 THEN
			--
			INSERT INTO public.instituicoes(descricao)
								     VALUES(rCursor.institution);
			--
		END IF;
		--
		SELECT id
		  INTO vInstituicoesId
		  FROM public.instituicoes
		 WHERE descricao = rCursor.institution;
		--
		--IMPORTA TIPOS DE ARTIGOS
		--
		SELECT count(*)
		  INTO vCont
		  FROM public.tipos_artigos
		 WHERE descricao = rCursor.article_type;
		--
		IF vCont = 0 THEN
			--
			INSERT INTO public.tipos_artigos(descricao)
									  VALUES(rCursor.article_type);
			--
		END IF;
		--
		SELECT id
		  INTO vTiposArquivosId
		  FROM public.tipos_artigos
		 WHERE descricao = rCursor.article_type;
		--
		--INSERE NA TABELA PRODUCOES COM A CODIFICAÇÃO ORGANIZADA
		--
		INSERT INTO public.producoes(pesquisador_id,
									 trabalho_id,
									 instituicao_id,
									 tipo_artigo_id,
									 data_inicial,
									 data_final,
									 data_publicacao)
							  VALUES(vPesquisadorId,
							  		 vTrabalhoId,
							  		 vInstituicoesId,
							  		 vTiposArquivosId,
							  		 rCursor.start_date,
							  		 rCursor.end_date,
							  		 rCursor.publication_date);
		--
	END LOOP;
	--
	RETURN 1;
	--
END$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.importacao()
  OWNER TO postgres;