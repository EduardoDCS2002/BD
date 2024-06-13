USE IndustryInsight;

-- RM1: Deve ser possível o sistema dar as informações de todos os Clientes que se pronunciaram interessados em alguma Empresa.
SELECT C.Nome,C.Email,C.Sexo,C.DataNascimento AS "Data de nascimento",E.Nome AS "Intesse na empresa" FROM cliente as C
    INNER JOIN empresacliente as EC ON C.ID = EC.Cliente
        INNER JOIN empresa as E ON EC.Empresa = E.ID;
        
-- RM2: O sistema deve conseguir definir um ranking de Workshops com a maior avaliação quantitativa.
SELECT Nome, AvaliacaoQuantitativa FROM workshop
    ORDER BY AvaliacaoQuantitativa DESC
    LIMIT 5;
    
-- RM3 - O sistema deve conseguir definir um ranking de Empresas que, por Workshop, fazem interessar mais Clientes.
SELECT  EW.empresa AS "ID de empresa", 
        E.nome, 
        E.Setor,
        COUNT(EC.Empresa)/COUNT(DISTINCT EW.Workshop) AS "Numero de clientes interessados por workshop" 
    FROM empresaworkshop AS EW
        INNER JOIN empresa as E ON EW.Empresa = E.ID
            INNER JOIN empresacliente AS EC ON EC.empresa = E.ID
                INNER JOIN cliente AS C ON EC.cliente = C.ID
        GROUP BY EW.empresa
        ORDER BY COUNT(*) DESC;

-- RM 6 - O sistema deve conseguir definir um ranking de Workshops por maior número de visitantes.
SELECT W.Nome,I.workshop as "Workshop ID",COUNT(I.workshop) as "Número de visitantes" FROM inscricao as I
	INNER JOIN workshop AS W ON W.ID = I.Workshop
		GROUP BY I.workshop
        ORDER BY COUNT(I.workshop) DESC;

-- RM 8 - O sistema deve ser capaz de dar a informação sobre os 5 visitantes que mais vezes se inscreveram nos Workshops.
SELECT C.ID as "Cliente ID" ,C.Nome,C.Sexo,COUNT(DISTINCT I.ID) as "Número de inscrições" FROM cliente as C
	INNER JOIN Inscricao as I ON C.ID = I.Cliente
    GROUP BY I.Cliente
    ORDER BY COUNT(DISTINCT I.ID) DESC, C.ID ASC
    LIMIT 5;
    
-- RM 10 - O sistema de base de dados deve retornar um ranking de setores de empresas que têm maior taxa de pessoas que interessaram.
SELECT 	E.Setor as "Setor das empresas",
		COUNT(E.setor) as "Número de interessados",
        COUNT(DISTINCT EW.Empresa) as "Empresas totais",
        COUNT(E.setor) / COUNT(DISTINCT EW.Empresa) AS "Taxa de interessados por workshop"
			FROM empresa AS E
			INNER JOIN empresacliente AS EC ON E.ID = EC.Empresa
				INNER JOIN empresaworkshop AS EW ON E.ID=EW.Empresa
		GROUP BY E.Setor
        ORDER BY COUNT(E.setor) / COUNT(DISTINCT EW.Empresa) DESC;
        
-- RM11 - Calcular o lucro de cada evento, isto é, o dinheiro ganho com as Inscrições 
       -- e com os preços de aluguer das bancadas das Empresas menos os gastos inseridos num dado Workshop.
SELECT  W.ID AS 'ID',
		W.Nome AS 'Nome',
		getProfitFromEmpresas(W.ID) AS "Total ganho com as bancadas", 
        getProfitFromClientes(W.ID) AS "Total ganho com inscrições", #210 para workshop 1
        getProfitFromEmpresas(W.ID) + getProfitFromClientes(W.ID) AS 'Total ganho',
        W.Gastos AS 'Gastos',
        getProfitFromEmpresas(W.ID) + getProfitFromClientes(W.ID) - W.Gastos AS 'Lucro'
			FROM Workshop AS W
        ORDER BY W.ID ASC;