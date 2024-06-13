USE IndustryInsight;
#DROP DATABASE IndustryInsight;

#Mostrar os clientes sem a informação de ID e NIF
CREATE VIEW vwClientes AS
	SELECT Nome,Email,sexo,DataNascimento FROM cliente;
    
#DROP VIEW vwClientes;
#SELECT * FROM vwClientes;

#View para mostrar quais os clientes e as suas participações nos workshops
CREATE VIEW vwClientParticipations AS
	SELECT C.Nome AS "Nome do Cliente"
		,W.Nome AS "Título do workshop"
        ,W.Data AS "Data do workshop",
        W.Morada AS "Local do workshop"
			FROM cliente AS C
				INNER JOIN clienteworkshop AS CW
				ON CW.Cliente = C.ID
					INNER JOIN workshop AS W
					ON W.Id = CW.Workshop;

#DROP VIEW vwClientParticipations;
#SELECT * FROM vwClientParticipations;

#View para mostrar as participações de empresas nos workshops agrupados por workshop
CREATE VIEW vwCompanyParticipations AS
	SELECT E.Nome AS "Empresa", 
			E.Email AS "Email da empresa",
            E.NIF AS "NIF da empresa",
            W.Nome AS "Partipou no workshop",
            EW.Preco AS "Preço de participação"
				FROM empresa AS E
                INNER JOIN empresaworkshop AS EW
                ON E.ID = EW.Empresa
					INNER JOIN workshop AS W
                    ON W.ID = EW.Workshop
						ORDER BY W.Nome ASC;

#DROP VIEW vwCompanyParticipations;
#SELECT * FROM vwCompanyParticipations;

#View para mostrar as inscrições realizadas ordenadas alfabeticamente por cliente
CREATE VIEW vwRegistrations AS 
	SELECT C.Nome AS "Nome do Cliente",
			I.Preco AS "Preço da inscrição",
			I.DataInscricao AS "Data de inscrição",
			W.Nome AS "Workshop"
			FROM inscricao AS I
				INNER JOIN Cliente AS C
				ON C.ID = I.Cliente
					INNER JOIN workshop AS W
					ON I.Workshop = W.ID
						ORDER BY C.Nome ASC;

#DROP VIEW vwRegistrations;
#SELECT * FROM vwRegistrations;

#View para mostrar os interesses que foram registados dos clientes ordenados alfabeticamente
CREATE VIEW vwInterests AS
	SELECT C.Nome AS "Nome do Cliente",
			E.Nome AS "Nome da empresa",
            E.Setor AS "Setor da empresa"
				FROM cliente AS C
					INNER JOIN empresacliente AS EC
					ON C.ID = EC.Cliente
						INNER JOIN empresa AS E
						ON E.ID = EC.Empresa
                        ORDER BY C.Nome;
                        
#DROP VIEW vwInterests;
#SELECT * FROM vwInterests;

#View para mostrar as avaliacoes ordenados decrescentemente por pontuacao 
CREATE VIEW vwRatings AS
	SELECT C.Nome AS "Nome do Cliente",
			W.Nome AS "Workshop avaliado",
            A.AvaliacaoQuantitativa AS "Pontuação dada",
            A.Comentario AS "Comentário",
			A.DataOmissao AS "Data da avaliação"
            FROM avaliacao AS A
				INNER JOIN cliente AS C
				ON C.ID = A.Cliente
					INNER JOIN workshop AS W
                    ON W.ID = A.Workshop
                    ORDER BY A.AvaliacaoQuantitativa DESC;

#DROP VIEW vwRatings;
#SELECT * FROM vwRatings;

#View para mostrar as empresas agrupadas nos seus devidos setores
CREATE VIEW vwSectors AS
	SELECT Setor, Nome as "Empresa" FROM empresa
		ORDER BY Setor ASC;
				
#DROP VIEW vwSectors;
#SELECT * FROM vwSectors;
            
#View para ver o número de participações por worskhop
CREATE VIEW vwNrParticipations AS
	SELECT W.Nome AS "Workshop",
			W.Data AS "Data do workshop",
			COUNT(I.workshop) as "Número de visitantes" FROM inscricao as I
			INNER JOIN workshop AS W ON W.ID = I.Workshop
				GROUP BY I.workshop
				ORDER BY W.Data ASC;
                
#DROP VIEW vwNrParticipations;
#SELECT * FROM vwNrParticipations;