﻿-- EXCLUINDO TABELAS, CASO EXISTAM
IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'MENSAGEM')
	DROP TABLE MENSAGEM;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'ENTREGA')
	DROP TABLE ENTREGA;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'ATIVIDADEVINCULADA')
	DROP TABLE ATIVIDADEVINCULADA;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'ATIVIDADE')
	DROP TABLE ATIVIDADE;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'SOLICITACAOMATRICULA')
	DROP TABLE SOLICITACAOMATRICULA;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'DISCIPLINAOFERTADA')
	DROP TABLE DISCIPLINAOFERTADA;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'DISCIPLINA')
	DROP TABLE DISCIPLINA;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'ALUNO')
	DROP TABLE ALUNO;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'PROFESSOR')
	DROP TABLE PROFESSOR;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'COORDENADOR')
	DROP TABLE COORDENADOR;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'USUARIO')
	DROP TABLE USUARIO;

IF EXISTS (SELECT * FROM SYS.TABLES WHERE NAME = 'CURSO')
	DROP TABLE CURSO;

-- TABELA USUARIO
CREATE TABLE USUARIO
(
	ID				INT			IDENTITY,
	LOGIN			VARCHAR(30) NOT NULL,
	SENHA			CHAR(8)		NOT NULL,
	DTEXPIRACAO		DATE		NOT NULL	CONSTRAINT DF_USU_DTEXP	DEFAULT ('1900/01/01'), 

	CONSTRAINT PK_USU		PRIMARY KEY (ID),
	CONSTRAINT UQ_USU_LOGIN	UNIQUE (LOGIN),
	CONSTRAINT CK_USU_SENHA	CHECK ( LEN(SENHA) = 8) -- EXTRA: SENHA OBRIGATORIAMENTE TERA 8 CARACTERES
);

-- TABELA ALUNO
CREATE TABLE ALUNO
(
	ID			INT				IDENTITY,
	IDUSUARIO	INT				NOT NULL,
	NOME		VARCHAR(50)		NOT NULL,
	EMAIL		VARCHAR(50)		NOT NULL,
	CELULAR		CHAR(11)		NOT NULL,
	RA			CHAR(7)			NOT NULL, 
	FOTO		VARCHAR(100)	,

	CONSTRAINT PK_ALUNO		PRIMARY KEY (ID),
	CONSTRAINT UQ_ALU_EMAIL UNIQUE (EMAIL),
	CONSTRAINT UQ_ALU_CELUL UNIQUE (CELULAR),
	CONSTRAINT UQ_ALU_RA	UNIQUE (RA) -- EXTRA: RA NÃO PODE DUPLICAR
);

--TABELA COORDENADOR
CREATE TABLE COORDENADOR
(
	ID			SMALLINT				IDENTITY,
	IDUSUARIO	INT				NOT NULL,
	NOME		VARCHAR(50)		NOT NULL,
	EMAIL		VARCHAR(50)		NOT NULL,
	CELULAR		CHAR(11)		NOT NULL

	CONSTRAINT PK_COORD		PRIMARY KEY (ID),
	CONSTRAINT UQ_COO_EMAIL UNIQUE (EMAIL),
	CONSTRAINT UQ_COO_CELUL UNIQUE (CELULAR)
);

--TABELA PROFESSOR
CREATE TABLE PROFESSOR
(
	ID			SMALLINT		IDENTITY,
	IDUSUARIO	INT,
	NOME		VARCHAR(50)		NOT NULL,  -- EXTRA: AJUSTE DO MODELO, FALTAVA O NOME DO PROF
	EMAIL		VARCHAR(50)		NOT NULL,
	CELULAR		CHAR(11)		NOT NULL,
	APELIDO		VARCHAR(50)		NOT NULL

	CONSTRAINT PK_PROFE		PRIMARY KEY (ID),
	CONSTRAINT UQ_PRO_EMAIL UNIQUE (EMAIL),
	CONSTRAINT UQ_PRO_CELUL UNIQUE (CELULAR)
);

-- TABELA DISCIPLINA
CREATE TABLE DISCIPLINA
(
	ID					     SMALLINT		IDENTITY,
	NOME					 VARCHAR(30)	NOT NULL,
	DATA					 DATE			NOT NULL CONSTRAINT DF_DIS_DATA	DEFAULT (GETDATE()),
	STATUS					 VARCHAR(10)	NOT NULL CONSTRAINT DF_DIS_STAT	DEFAULT ('ABERTA'),
	PLANODEENSINO			 VARCHAR(1000)	NOT NULL,
	CARGAHORARIA			 TINYINT		NOT NULL,
	COMPETENCIAS			 VARCHAR(1000)	NOT NULL,
	HABILIDADES				 VARCHAR(1000)	NOT NULL,
	EMENTA					 VARCHAR(1000)	NOT NULL,
	CONTEUDOPROGRAMATICO	 VARCHAR(1000)	NOT NULL,
	BIBLIOGRAFIABASICA		 VARCHAR(1000)	NOT NULL,
	BIBLIOGRAFIACOMPLEMENTAR VARCHAR(1000)	NOT NULL,
	PERCENTUALPRATICO		 TINYINT		NOT NULL,
	PERCENTUALTEORICO		 TINYINT		NOT NULL,
	IDCOORDENADOR			 SMALLINT		NOT NULL,
	
	CONSTRAINT PK_DISCI		PRIMARY KEY (ID),
	CONSTRAINT UQ_DIS_NOME	UNIQUE (NOME),
	CONSTRAINT CK_DIS_STAT	CHECK ( STATUS IN ('ABERTA', 'FECHADA' )),
	CONSTRAINT CK_DIS_CARG	CHECK ( CARGAHORARIA IN (40,80)),
	CONSTRAINT CK_DIS_PERP	CHECK ( PERCENTUALPRATICO BETWEEN 0 and 100),
	CONSTRAINT CK_DIS_PERT	CHECK ( PERCENTUALTEORICO BETWEEN 0 AND 100),
	CONSTRAINT CK_DIS_PERC	CHECK ( PERCENTUALTEORICO + PERCENTUALPRATICO = 100 )  -- EXTRA: PERC PRATICO + TEORICO = 100%
);

-- TABELA DISCIPLINA OFERTADA
CREATE TABLE DISCIPLINAOFERTADA
(
	ID					    INT			IDENTITY,
	IDCOORDENADOR			SMALLINT	NOT NULL,
	DTINICIOMATRICULA		DATE,
	DTFIMMATRICULA			DATE,
	IDDISCIPLINA			SMALLINT	NOT NULL,
	IDCURSO					TINYINT		NOT NULL,
	ANO						SMALLINT	NOT NULL,
	SEMESTRE				TINYINT		NOT NULL,
	TURMA					CHAR(1)		NOT NULL,
	IDPROFESSOR				SMALLINT,
	METODOLOGIA				VARCHAR(1000),
	RECURSOS				VARCHAR(1000),
	CRITERIOAVALIACAO		VARCHAR(1000),
	PLANODEAULAS			VARCHAR(1000),

	CONSTRAINT PK_DOFER		PRIMARY KEY (ID),
	CONSTRAINT CK_DOFER_ANO CHECK(ANO BETWEEN 1900 AND 2100),
	CONSTRAINT CK_DOFER_SEM CHECK(SEMESTRE IN (1,2)),
	CONSTRAINT CK_DOFER_TUR CHECK(TURMA BETWEEN 'A' AND 'Z'),
	CONSTRAINT CK_DOFER_PRO CHECK 
		(CASE 
			WHEN IDPROFESSOR  IS NULL 
			THEN 1
			WHEN IDPROFESSOR  IS NOT NULL AND METODOLOGIA IS NOT NULL AND
				 RECURSOS	  IS NOT NULL AND CRITERIOAVALIACAO IS NOT NULL AND
				 PLANODEAULAS IS NOT NULL 
			THEN 1
			ELSE 0
		END = 1), -- EXTRA VALIDAÇÃO SE ESTIVER SEM PROF OK. CASO PROF TEM QUE TER METODOLOGIA, RECURSO, CRITERIO E PLANO.
	CONSTRAINT UQ_DOFER_COM	UNIQUE (IDDISCIPLINA, IDCURSO, ANO, SEMESTRE, TURMA)
);				 

--TABELA CURSO
CREATE TABLE CURSO
(
	ID		TINYINT		IDENTITY,
	NOME	VARCHAR(50)	NOT NULL,

	CONSTRAINT PK_CURSO			PRIMARY KEY (ID),
	CONSTRAINT UQ_CURSO_NOME	UNIQUE (NOME)
);


-- TABELA SOLICITACAO MATRICULA
CREATE TABLE SOLICITACAOMATRICULA
(
	ID				INT			IDENTITY,
	IDALUNO			INT			NOT NULL,
	IDDOFERTADA		INT			NOT NULL,
	DTSOLICITACAO	DATETIME	NOT NULL CONSTRAINT DF_SMATRI_DT DEFAULT (GETDATE()),
	IDCOORDENADOR	SMALLINT, 
	STATUS			VARCHAR(15)	NOT NULL CONSTRAINT DF_SMATRI_ST DEFAULT ('SOLICITADA'),

	CONSTRAINT	PK_SMATRI	 PRIMARY KEY (ID),
	CONSTRAINT	CK_SMATRI_ST CHECK (STATUS IN ('SOLICITADA', 'APROVADA','REJEITADA', 'CANCELADA' ))
);

-- TABELA ATIVIDADE
CREATE TABLE ATIVIDADE
(
	ID				INT				IDENTITY,
	TITULO			VARCHAR(30)		NOT NULL,
	DESCRICAO		VARCHAR(100),
	CONTEUDO		VARCHAR(8000)	NOT NULL,
	TIPO 			VARCHAR(15)		NOT NULL, 
	EXTRAS			VARCHAR(100),
	IDPROFESSOR		SMALLINT,

	CONSTRAINT	PK_ATIVIDADE	PRIMARY KEY (ID),
	CONSTRAINT	UQ_ATIVI_TITU	UNIQUE (TITULO),	 
	CONSTRAINT	CK_ATIVI_TIPO	CHECK (TIPO IN ('RESPOSTA ABERTA', 'TESTE')),
);

-- TABELA ATIVIDADE VINCULADA
CREATE TABLE ATIVIDADEVINCULADA
(
	ID				INT			 IDENTITY,
	IDATIVIDADE		INT			 NOT NULL,
	IDPROFESSOR		SMALLINT	 NOT NULL,
	IDDOFERTADA		INT			 NOT NULL,
	ROTULO			VARCHAR(100) NOT NULL,
	STATUS			VARCHAR(15)	 NOT NULL,
	DTINIRESPOSTA	DATETIME	 NOT NULL,
	DTFIMRESPOSTA	DATETIME	 NOT NULL,

	CONSTRAINT	PK_AVINCULADA	PRIMARY KEY (ID),
	CONSTRAINT	UQ_AVINC		UNIQUE (ROTULO, IDATIVIDADE, IDDOFERTADA),
	CONSTRAINT  CK_AVINC_STAT	CHECK (STATUS IN ('DISPONIBILIZADA','ABERTA', 'FECHADA','ENCERRADA','PRORROGADA'))
);

-- TABELA ENTREGA
CREATE TABLE ENTREGA
(
	ID				INT				IDENTITY,
	IDALUNO			INT				NOT NULL,
	IDAVINCULADA	INT				NOT NULL,
	TITULO			VARCHAR(100)	NOT NULL,
	RESPOSTA		VARCHAR(8000)	NOT NULL,
	DTENTREGA		DATETIME		NOT NULL CONSTRAINT DF_ENTRE_DTEN DEFAULT (GETDATE()),
	STATUS			VARCHAR(10)		NOT NULL CONSTRAINT DF_ENTRE_STAT	DEFAULT	('ENTREGUE'),
	IDPROFESSOR		SMALLINT,
	NOTA			DECIMAL(4,2),
	DTAVALIACAO		DATETIME,
	OBS				VARCHAR(500),

	CONSTRAINT	PK_ENTREGA		PRIMARY KEY (ID),
	CONSTRAINT  UQ_ENTRE		UNIQUE (IDALUNO, IDAVINCULADA),
	CONSTRAINT  CK_ENTRE_STAT	CHECK (STATUS IN ('ENTREGUE','CORRIGIDO')),
	CONSTRAINT  CK_ENTRE_NOTA	CHECK (NOTA BETWEEN 0 AND 10),
	CONSTRAINT	CK_ENTRE_CORR	CHECK
		(CASE 
			WHEN IDPROFESSOR  IS NULL 
			THEN 1
			WHEN IDPROFESSOR  IS NOT NULL AND 
				 NOTA IS NOT NULL AND
				 DTAVALIACAO = GETDATE() AND 
				 STATUS = 'CORRIGIDO'
			THEN 1
			ELSE 0
		END = 1), -- EXTRA VALIDAÇÃO SE ESTIVER SEM PROF OK. CASO PROF CORRIGIR, TEM QUE TER NOTA E DATA TEM QUE SER DATA/HORA ATUAL.
)

-- TABELA MENSAGEM
CREATE TABLE MENSAGEM
(
		ID				INT				IDENTITY,
		IDALUNO			INT				NOT NULL,
		IDPROFESSOR		SMALLINT		NOT NULL,
		ASSUNTO			VARCHAR(100)	NOT NULL,
		REFERENCIA		VARCHAR(100)	NOT NULL,
		CONTEUDO		VARCHAR(500)	NOT NULL,
		STATUS			VARCHAR(10)		NOT NULL CONSTRAINT DF_MENSA_STAT DEFAULT 'ENVIADO',
		DTENVIO			DATETIME		NOT NULL CONSTRAINT DF_MENSA_DTEN DEFAULT GETDATE(),
		DTRESPOSTA		DATETIME,
		RESPOSTA		VARCHAR(500),
		
		CONSTRAINT	PK_MENSAGEM		PRIMARY KEY (ID),
		CONSTRAINT	CK_MENSA_STAT	CHECK (STATUS IN ( 'ENVIADO', 'LIDO', 'RESPONDIDO' )),
		CONSTRAINT	CK_MENSA_RESP	CHECK
		(CASE 
			WHEN DTRESPOSTA  IS NULL 
			THEN 1
			WHEN DTRESPOSTA  IS NOT NULL AND 
				 RESPOSTA IS NOT NULL AND
				 STATUS = 'RESPONDIDO'
			THEN 1
			ELSE 0
		END = 1), -- EXTRA VALIDAÇÃO SE ESTIVER SEM DTRESPOSTA OK. CASO MENSAGEM RESPONDIDA, TEM QUE TER DTRESPOSTA, RESPOSTA E STATUS TEM QUE SER RESPONDIDO.
)

-- INCLUINDO AS FKs

ALTER TABLE COORDENADOR ADD
	CONSTRAINT FK_COORD_USU	FOREIGN KEY (IDUSUARIO) REFERENCES USUARIO (ID);

ALTER TABLE PROFESSOR ADD
	CONSTRAINT FK_PROFE_USU	FOREIGN KEY (IDUSUARIO) REFERENCES USUARIO (ID);

ALTER TABLE ALUNO ADD
	CONSTRAINT FK_ALUNO_USU	FOREIGN KEY (IDUSUARIO) REFERENCES USUARIO (ID);

ALTER TABLE DISCIPLINA ADD
	CONSTRAINT FK_DISCI_COORD FOREIGN KEY (IDCOORDENADOR) REFERENCES COORDENADOR (ID);

ALTER TABLE DISCIPLINAOFERTADA ADD
	CONSTRAINT FK_DOFER_COORD FOREIGN KEY (IDCOORDENADOR) REFERENCES COORDENADOR (ID),
	CONSTRAINT FK_DOFER_DISCI FOREIGN KEY (IDDISCIPLINA)  REFERENCES DISCIPLINA (ID),
	CONSTRAINT FK_DOFER_CURSO FOREIGN KEY (IDCURSO)		  REFERENCES CURSO (ID),
	CONSTRAINT FK_DOFER_PROFE FOREIGN KEY (IDPROFESSOR)   REFERENCES PROFESSOR (ID);

ALTER TABLE SOLICITACAOMATRICULA ADD
	CONSTRAINT FK_SMATR_COORD FOREIGN KEY (IDCOORDENADOR) REFERENCES COORDENADOR (ID),
	CONSTRAINT FK_SMATR_DISCI FOREIGN KEY (IDDOFERTADA)   REFERENCES DISCIPLINAOFERTADA (ID),
	CONSTRAINT FK_SMATR_ALUNO FOREIGN KEY (IDALUNO)		  REFERENCES ALUNO (ID);

ALTER TABLE ATIVIDADE ADD
	CONSTRAINT FK_ATIV_PROFE FOREIGN KEY (IDPROFESSOR)   REFERENCES PROFESSOR (ID);

ALTER TABLE ATIVIDADEVINCULADA ADD
	CONSTRAINT FK_AVINC_ATIVI FOREIGN KEY (IDATIVIDADE)	  REFERENCES ATIVIDADE (ID),
	CONSTRAINT FK_AVINC_DISCI FOREIGN KEY (IDDOFERTADA)   REFERENCES DISCIPLINAOFERTADA (ID),
	CONSTRAINT FK_AVINC_PROFE FOREIGN KEY (IDPROFESSOR)   REFERENCES PROFESSOR (ID);

ALTER TABLE ENTREGA ADD
	CONSTRAINT FK_ENTRE_PROFE FOREIGN KEY (IDPROFESSOR)   REFERENCES PROFESSOR (ID),
	CONSTRAINT FK_ENTRE_AVINC FOREIGN KEY (IDAVINCULADA)  REFERENCES ATIVIDADEVINCULADA (ID),
	CONSTRAINT FK_ENTRE_ALUNO FOREIGN KEY (IDALUNO)		  REFERENCES ALUNO (ID);

ALTER TABLE MENSAGEM ADD
	CONSTRAINT FK_MENSA_PROFE FOREIGN KEY (IDPROFESSOR)   REFERENCES PROFESSOR (ID),
	CONSTRAINT FK_MENSA_ALUNO FOREIGN KEY (IDALUNO)		  REFERENCES ALUNO (ID);

-- ALUNOS
INSERT INTO USUARIO (LOGIN, SENHA) VALUES 
('GILSON.ALMEIDA', 'G1501375'),
('SEBASTIAO.RODRIGUES', 'S1602440'),
('VALDIR.CASTRO', 'S1602396'),
('LUIZ.MELO', 'L1701777'),
('FRANCISCO.JESUS', 'F1602405'),
('NELSON.MOREIRA', 'N1602128'),
('RAIMUNDO.MORAES', 'R1602230'),
('FABIO.MOURA', 'F1601249'),
('ANDRE.COSTA', 'A1701595'),
('MARCIO.BATISTA', 'M1601576'),
('VINICIUS.CONCEICAO', 'V1501650'),
('JOAO.SOUSA', 'J1702249'),
('ANTONIO.MAGALHAES', 'A1702525'),
('JOSE.MORAIS', 'J1501148'),
('JONATHAN.FILHO', 'J1502810'),
('PAULO.MELO', 'P1602770'),
('ALESSANDRO.DIAS', 'A1602697'),
('EVERTON.MARTINS', 'E1602173'),
('EDSON.FERNANDES', 'E1601713'),
('EMERSON.MENEZES', 'E1602326'),
('CICERO.SANTANA', 'C1501257'),
('MICHELE.GARCIA', 'M1501464'),
('DOUGLAS.XAVIER', 'D1502465'),
('RODRIGO.GOMES', 'R1502808'),
('ALEXANDRE.DIAS', 'A1601975'),
('MAURO.CARVALHO', 'M1702530'),
('EDUARDO.VIEIRA', 'E1602305'),
('FABRICIO.MACHADO', 'F1701582'),
('DANIEL.ROCHA', 'D1501352'),
('JEAN.NEVES', 'J1701910'),
('TAMIRES.CAVALCANTE', 'T1701166'),
('DIEGO.NETO', 'D1502850'),
('MARCELO.SANTOS', 'M1602346'),
('LEONARDO.CUNHA', 'L1601418'),
('ALAN.AGUIAR', 'A1702476'),
('ADRIANA.MACHADO', 'A1702619'),
('MARIA.NASCIMENTO', 'M1502116'),
('ANA.FARIAS', 'A1702648'),
('RENATA.COSTA', 'R1702436'),
('VERA.CARDOSO', 'V1602388'),
('ELIANE.MENDES', 'E1701548'),
('JESSICA.PEREIRA', 'J1502514'),
('PRISCILA.FARIAS', 'P1601584'),
('ROSANGELA.RIBEIRO', 'R1502845'),
('LUCIANA.FERREIRA', 'L1601609'),
('ELAINE.BRAGA', 'E1702717'),
('ANTONIA.FILHO', 'A1602719'),
('PATRICIA.MORAIS', 'P1601963'),
('MARIA.MORAES', 'M1602611'),
('CLAUDIA.MOURA', 'C1601449')

-- PROFESSORES
INSERT INTO USUARIO (LOGIN, SENHA) VALUES 
('ALAN.OLIVEIRA', '12345678'),
('ALBERTO.JUNIOR', '12345678'),
('ALEXANDRE.MARTINS', '12345678'),
('ALEXANDRE.RANGEL', '12345678'),
('ALVARO.TAKEI', '12345678'),
('ANA.SANTOS', '12345678'),
('BRUNO.KALKEVICIUS', '12345678'),
('CEZAR.BELLINI', '12345678'),
('EDSON.SILVA', '12345678'),
('EDSON.TSUKIMOTO', '12345678'),
('EDUARDO.QUEIROZ', '12345678')

INSERT INTO USUARIO (LOGIN, SENHA) VALUES 
('EMILIO.RESENDE', '12345678'),
('FELIPE.DIAS', '12345678'),
('FERNANDO.ZUHER', '12345678'),
('FRANCESCA.ROMANELLI','12345678'),
('GISELDA.PEREIRA', '12345678'),
('GUILHERME.LOHMANN', '12345678'),
('GUSTAVO.FERREIRA', '12345678'),
('ILANA.CONCILIO', '12345678'),
('IZA.MELÃO', '12345678'),
('JOÃO.COUTINHO', '12345678'),
('JOSÉ.PRADO', '12345678'),
('LEONARDO.TAKUNO', '12345678'),
('LUCAS.GONÇALVES', '12345678'),
('LUCIANO.CROCCO', '12345678'),
('MARCEL.PIRES', '12345678')

INSERT INTO USUARIO (LOGIN, SENHA) VALUES 
('MARCELO.SILVA', '12345678'),
('MARCELO.TERRA', '12345678'),
('MARCO.JEUNON', '12345678'),
('OSVALDO.TAKAI', '12345678'),
('PEDRO.PRADO', '12345678'),
('PLÍNIO.FILHO', '12345678'),
('RENATO.SANTOS', '12345678'),
('RODRIGO.PIASSI', '12345678'),
('SÉRGIO.BRUZETTI', '12345678'),
('VANDERSON.BOSSI', '12345678'),
('VICTOR.OLIVEIRA', '12345678'),
('VLADIMIR.CHAGAS', '12345678'),
('Bruno.Lima','12345678'),
('Ayao.Okamoto','12345678'),
('Alan.Carvalho ','12345678')