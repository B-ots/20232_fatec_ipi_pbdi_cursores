DROP TABLE tb_top_youtubers;


CREATE TABLE tb_top_youtubers(
	cod_top_youtubers SERIAL PRIMARY KEY,
	rank INT,
	youtuber VARCHAR (200),
	subscribers INT,
	video_views VARCHAR (200),
	video_count INT,
	category VARCHAR (200),
	started INT
);

COPY tb_top_youtubers(youtuber, subscribers, video_views, video_count, category, started)
FROM 'C:\Users\aluno\bots\pbd1\cursores\16_Top_YouTube_Channels_Data.csv'
DELIMITER ','
CSV HEADER;

SELECT *FROM tb_top_youtubers;


DO $$
	DECLARE
		--1. declaração do cursor
		--esse cursor é unbound por não ser associado a nenhuma query
		cur_nomes_youtubers REFCURSOR;
		--para armazenar o nome do youtuber a cada iteração
		v_youtuber VARCHAR(200);
	BEGIN
		--2. abertura do cursor
		OPEN cur_nomes_youtubers FOR
			SELECT youtuber
				FROM tb_top_youtubers;
		LOOP
			--3. Recuperação dos dados de interesse
			FETCH cur_nomes_youtubers INTO v_youtuber;
			--FOUND é uma variável especial que indica
			EXIT WHEN NOT FOUND;
			RAISE NOTICE '%', v_youtuber;
		END LOOP;
		--4. Fechamento do cursos
	CLOSE cur_nomes_youtubers;
END;
$$
