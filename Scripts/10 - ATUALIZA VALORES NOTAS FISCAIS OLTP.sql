/* ATUALIZA NOTA FISCAL */

CREATE VIEW V_NOTA_FISCAL AS
SELECT ID_NOTA_FISCAL, SUM(TOTAL) AS SOMA
FROM ITEM_NOTA 
GROUP BY ID_NOTA_FISCAL
GO

SELECT * FROM V_NOTA_FISCAL
WHERE ID_NOTA_FISCAL = 1000 
GO

CREATE VIEW V_CARGA_NF AS
SELECT IDNOTA, N.TOTAL TOTALNOTA, I.SOMA
FROM NOTA_FISCAL N
INNER JOIN V_NOTA_FISCAL I
ON IDNOTA = ID_NOTA_FISCAL
GO

SELECT * FROM V_CARGA_NF
GO

UPDATE V_CARGA_NF SET TOTALNOTA = SOMA
GO

/* REALIZANDO CONSULTA NO AMBIENTE OLTP */

CREATE VIEW V_RELATORIO_OLTP AS
SELECT C.NOME, C.SOBRENOME AS "CLIENTE", C.SEXO, 
N.DATA, N.IDNOTA, P.PRODUTO, N.TOTAL
FROM CLIENTE C
INNER JOIN NOTA_FISCAL N
ON C.IDCLIENTE = N.ID_CLIENTE
INNER JOIN ITEM_NOTA I
ON N.IDNOTA = I.ID_NOTA_FISCAL
INNER JOIN PRODUTO P
ON P.IDPRODUTO = I.ID_PRODUTO
GO

SELECT * FROM V_RELATORIO_OLTP