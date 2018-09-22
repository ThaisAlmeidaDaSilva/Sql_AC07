
--Igor Zilli RA 1801298
--Ariana Oliveira RA 1800582
--Anderson Maccari RA 1800077
--Thiago Silva RA 1701092
--Matheus Marques RA 1801198

CREATE TABLE UNIDADES
(
COD_UNIDADE  INT IDENTITY(1,1) NOT NULL,
NOME_UNIDADE VARCHAR(50),

CONSTRAINT PK_UNIDADES PRIMARY KEY (COD_UNIDADE)
);

INSERT INTO UNIDADES
(NOME_UNIDADE )

VALUES 
('PE�AS'),
('METROS'),
('QUILOGRAMAS'),
('D�ZIAS'),
('PACOTE'),
('CAIXA')


SELECT * FROM UNIDADES;
CREATE TABLE CATEGORIAS
(
COD_CATEGORIA INT IDENTITY(1,1) NOT NULL,
NOME_CATEGORIA VARCHAR(100),

CONSTRAINT PK_CATEGORIAS PRIMARY KEY (COD_CATEGORIA)

)

SELECT * FROM CATEGORIAS;

INSERT INTO CATEGORIAS
(NOME_CATEGORIA  )

VALUES 
('MOUSE'),
('PEN-DRIVE'),
('MONITOR DE VIDEO'),
('TECLADO'),
('CPU'),
('CABO DE REDE')



 
CREATE TABLE  PRODUTOS
(
COD_PRODUTO  INT IDENTITY(1,1) NOT NULL,
NOME_PRODUTO VARCHAR(100),
COD_UNIDADE INT,
COD_CATEGORIA INT,
QTD_ESTOQUE NUMERIC(6),
QTD_MINIMA NUMERIC(4),
PRECO_CUSTO NUMERIC(10,2),
PRECO_VENDA NUMERIC(10,2),
CARACTERISTICA_TECNICA VARCHAR(1000),

CONSTRAINT FK_UNIDADE FOREIGN KEY (COD_UNIDADE ) REFERENCES UNIDADES (COD_UNIDADE),
CONSTRAINT FK_CATEGORIA FOREIGN KEY (COD_CATEGORIA) REFERENCES CATEGORIAS (COD_CATEGORIA)
)

SELECT * FROM PRODUTOS
WHERE COD_CATEGORIA = 2;

INSERT INTO PRODUTOS
(NOME_PRODUTO , COD_UNIDADE , COD_CATEGORIA , QTD_ESTOQUE, QTD_MINIMA , PRECO_CUSTO, PRECO_VENDA)

VALUES 
('Caneta Azul' , 1,1,150,40,0.50, 0.75),
('Caneta Verde' , 1,1,50,40,0.50, 0.75),
('Caneta Vermelha', 1,1,80,35,0.50, 0.75),
('L�pis' , 1,1,400,80,0.50, 0.8),
('R�gua' , 1,1,40,10,1, 1.5)


-- UPDATE DA TB_PRODUTO
UPDATE TB_PRODUTO
SET PRECO_CUSTO *= 1.15
WHERE COD_TIPO = 2;

UPDATE TB_PRODUTO
SET PRECO_VENDA = PRECO_CUSTO * 1.3
WHERE COD_TIPO = 2

UPDATE TB_PRODUTO
SET IPI = 5
WHERE COD_TIPO = 3;


UPDATE TB_PRODUTO
SET QTD_MINIMA *= 0.9 

-- UPDATE DA TB_CLIENTE

UPDATE TB_CLIENTE
SET ENDERECO =' AV. CELSO GARCIA, 1234',
BAIRRO= 'TATUAPE',
CIDADE= 'SAO PAULO',
ESTADO='SP',
CEP= '03407080'
WHERE CODCLI  = 11


UPDATE TB_CLIENTE
SET END_COB = ENDERECO,
BAI_COB = BAIRRO,
CID_COB = CIDADE,
EST_COB = ESTADO,
CEP_COB = CEP
WHERE  CODCLI  = 13


UPDATE TB_CLIENTE
SET ICMS = 7
WHERE ESTADO NOT IN ('RJ',' RO', 'AC', 'RR', 'MG','PR', 'SC',' RS', 'MS', 'MT', 'SP');

-- UPDATE DA TB_ITENSPEDIDO

UPDATE TB_ITENSPEDIDO
SET DESCONTO = 7
WHERE ID_PRODUTO = 8 AND DATA_ENTREGA <= '2007.1.31' AND DATA_ENTREGA >= '2007.1.1' AND QUANTIDADE > 1000

UPDATE TB_ITENSPEDIDO
SET DESCONTO = 0
WHERE DATA_ENTREGA > '2007.6.30' AND QUANTIDADE < 1000 AND DESCONTO > 0

-- CRIANDO A TABELA TB_VENDEDOR_TMP

SELECT * 
INTO TB_VENDEDOR_TMP
FROM TB_VENDEDOR;

-- DELETE DA TB_VENDEDOR_TMP

DELETE TB_VENDEDOR_TMP
WHERE CODVEN > 5

-- CRIANDO A TABELA TB_COPIA_PEDIDO

SELECT * 
INTO TB_COPIA_PEDIDO
FROM TB_PEDIDO;

-- DELETE DA TB_COPIA_PEDIDO

DELETE TB_COPIA_PEDIDO
WHERE CODVEN = 2

DELETE TB_COPIA_PEDIDO
WHERE DATA_EMISSAO >='2007.1.1' AND DATA_EMISSAO <='2007.6.30'

TRUNCATE TABLE TB_COPIA_PEDIDO


