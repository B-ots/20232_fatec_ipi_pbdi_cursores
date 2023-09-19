DO
$$
DECLARE
	-- 1. DECLARAÇÃO DO CURSOR (UNBOUND - NÃO VINCULADO)
	cur_delete REFCURSOR;
	tupla RECORD;
BEGIN
	--2. ABERTURA DO CURSOR
	--SCROLL - PARA DESCER E SUBIR - ESSE CURSOR QUE EU ESTOU ABRINDO VAI DESCER, MAS EVENTUALMENTE VAI SUBIR
	OPEN cur_delete SCROLL FOR
		SELECT * FROM tb_top_youtubers;
	LOOP
	-- 3. RECUPERAÇÃO DE DADOS
		FETCH cur_delete INTO tupla;
		EXIT WHEN NOT FOUND;
		-- O QUE OLHAR PRO VIDEO_COUNT DA TUPLA?
		IF tupla.video_count = NULL THEN
			DELETE FROM
				tb_top_youtubers
			WHERE CURRENT OF cur_delete;
		END IF;
	END LOOP;
	
	LOOP --O BACKWORD FAZ VOLTAR PRA TRAS
		FETCH BACKWARD FROM cur_delete INTO tupla;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', tupla;	
	END LOOP;
	-- 4. ENCERRAMENTO DO CURSOR
	CLOSE cur_delete;
	
END;
$$




--cursor com parametro
-- DO $$
-- DECLARE
-- 	v_ano INT := 2010;
-- 	v_inscritosINT := 60000000;
-- 	v_youtuber VARCHAR(200);
-- 	--vinculado (bound)
-- 	--1.declaração do cursor
-- 	cur_ano_inscritos CURSOR (ano INT, inscritos INT) FOR SELECT youtuber FROM tb_top_youtubers WHERE
-- 	started >= ano AND subscribers >= inscritos;
-- BEGIN 
-- 	--passagem pela ordem
-- 	--OPEN cur_ano_inscritos(v_ano, v_inscritos);
	
-- 	--passagem por nome
-- 	--2. abertura do cursor 
-- 	OPEN cur_ano_inscritos(inscritos := v_inscritos, ano :=v_ano);
-- 	LOOP
-- 		--3. recuperação de dados
-- 		FETCH cur_ano_inscritos INTO v_youtuber;
-- 		EXIT WHEN NOT FOUND;
-- 		RAISE NOTICE '%', v_youtuber;
-- 	END LOOP;
-- 	--4. Fechamento do cursor 
-- 	CLOSE cur_ano_inscritos;
-- END;
-- $$

-- --cursor vinculado (bound)
-- --nome do youtuber e o numero de inscritos
-- --concatenando e exibindo apenas o final
-- DO $$
-- DECLARE
-- 	--1. Declaração cursor 
-- 	cur_nomes_e_inscritos CURSOR FOR SELECT youtuber, subscribers FROM tb_top_youtubers;
-- 	--um record pode representar uma linha
-- 	--tupla.nome dá acesso ao valor na coluna nome
-- 	tupla RECORD;
-- 	resultado TEXT DEFAULT '';
-- BEGIN
-- 	--2. Abrir o cursor 
-- 	OPEN cur_nomes_e_inscritos;
-- 	--3. Recuperação dos dados
-- 	FETCH cur_nomes_e_inscritos INTO tupla;
-- 	WHILE FOUND LOOP
-- 		resultado := resultado || tupla.youtuber || ':' || tupla.subscribers || ',';
-- 		--3. Recuperação dos dados
-- 		FETCH cur_nomes_e_inscritos INTO tupla;
		
-- 	END LOOP;
-- 		--4. Fechar o cursor
-- 	CLOSE cur_nomes_e_inscritos;
-- 	RAISE NOTICE '%', resultado;
	
-- END;
-- $$

-- --cursor unbound com query dinamica
-- --dinamica: armazenada como string
-- --exibir canais que começaram somente a partir 
-- --de um ano especifico
-- DO
-- $$
-- DECLARE
-- 	--1. Declaração 
-- 	cur_nomes_a_partir_de REFCURSOR;
-- 	v_youtuber VARCHAR(200);
-- 	v_ano INT :=2008;
-- 	v_nome_tabela VARCHAR(200) :='tb_top_youtubers';
-- BEGIN
-- 	--2. abertura do cursor
-- 	OPEN cur_nomes_a_partir_de FOR EXECUTE
-- 	format
-- 	(
-- 	'
-- 		SELECT youtuber FROM %s WHERE started >= $1
-- 	',
-- 		v_nome_tabela
-- 	)USING v_ano;
-- 	LOOP
-- 		-- 3. Recuperação dos dados
-- 		FETCH cur_nomes_a_partir_de INTO v_youtuber;
-- 		EXIT WHEN NOT FOUND;
-- 		RAISE NOTICE '%', v_youtuber;
-- 	END LOOP;
-- 	--4. Fechar o cursor
-- 	CLOSE cur_nomes_a_partir_de;
-- END;
-- $$

-- DROP TABLE tb_top_youtubers;


-- CREATE TABLE tb_top_youtubers(
-- 	cod_top_youtubers SERIAL PRIMARY KEY,
-- 	rank INT,
-- 	youtuber VARCHAR (200),
-- 	subscribers INT,
-- 	video_views VARCHAR (200),
-- 	video_count INT,
-- 	category VARCHAR (200),
-- 	started INT
-- );

-- COPY tb_top_youtubers(youtuber, subscribers, video_views, video_count, category, started)
-- FROM 'C:\Users\aluno\bots\pbd1\cursores\16_Top_YouTube_Channels_Data.csv'
-- DELIMITER ','
-- CSV HEADER;

-- SELECT *FROM tb_top_youtubers;


-- DO $$
-- 	DECLARE
-- 		--1. declaração do cursor
-- 		--esse cursor é unbound por não ser associado a nenhuma query
-- 		cur_nomes_youtubers REFCURSOR;
-- 		--para armazenar o nome do youtuber a cada iteração
-- 		v_youtuber VARCHAR(200);
-- 	BEGIN
-- 		--2. abertura do cursor
-- 		OPEN cur_nomes_youtubers FOR
-- 			SELECT youtuber
-- 				FROM tb_top_youtubers;
-- 		LOOP
-- 			--3. Recuperação dos dados de interesse
-- 			FETCH cur_nomes_youtubers INTO v_youtuber;
-- 			--FOUND é uma variável especial que indica
-- 			EXIT WHEN NOT FOUND;
-- 			RAISE NOTICE '%', v_youtuber;
-- 		END LOOP;
-- 		--4. Fechamento do cursos
-- 	CLOSE cur_nomes_youtubers;
-- END;
-- $$
