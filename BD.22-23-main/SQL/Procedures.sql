USE IndustryInsight;

-- Aquando a criação de uma Inscrição o Cliente que a fez deverá ser automaticamente associado à Workshop a qual se inscreveu 
-- na tabela ClienteWorkshop. RM13
DELIMITER $$
CREATE PROCEDURE prCreateInscricao (
	IN newPreco DECIMAL(8,2),
    IN newDataInscricao DATE,
    IN newCliente INT,
    IN newWorkshop INT,
    OUT prResultado VARCHAR(150)
    )
prCreateInscricao:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS;
                ROLLBACK;
            END;
	-- Defini-se o início das transações.
	START TRANSACTION;
	-- Confirma-se que o Cliente existe na tabela Cliente. 
    -- Caso não exista é abortado a inserção de quaisquer dados, é dado um valor a prResultado que indica o erro e sai-se 
    -- do procedimento.
    IF (SELECT COUNT(*) FROM Cliente WHERE Cliente.ID = newCliente) = 0 THEN
		ROLLBACK;
        SET prResultado = "O Cliente fornecido não existe.";
        LEAVE prCreateInscricao;
    END IF;
    -- Inserção dos dados da Inscrição na tabela Inscricao.
    INSERT INTO Inscricao
		(Preco, DataInscricao, Cliente, Workshop)
			VALUES 
				(newPreco, newDataInscricao, newCliente, newWorkshop);
    -- Confirma-se que a Workshop existe na tabela Workshop.
    -- Caso não exista é abortado a inserção de quaisquer dados, é dado um valor a prResultado que indica o erro e 
    -- sai-se do procedimento.
    IF (SELECT COUNT(*) FROM Workshop WHERE Workshop.ID = newWorkshop) = 0 THEN
		ROLLBACK;
        SET prResultado = "A Workshop fornecida não existe.";
        LEAVE prCreateInscricao;
    END IF;
	-- Inserção dos IDs do Cliente e da Workshop na tabela ClienteWorkshop.
    INSERT INTO ClienteWorkshop
		(Cliente, Workshop)
			VALUES
				(newCliente, newWorkshop);
    -- Usa-se a função COMMIT para indicar a finalização de todas as transações e dá-se um valor a prResultado para indicar 
    -- o sucesso do procedimento.
    COMMIT;
    SET prResultado = "Criação Concluída";
END
$$



-- O sistema deve apenas registar Avaliações que apenas têm uma avaliação quantitativa entre 0 e 5. RM14.
DELIMITER $$
CREATE PROCEDURE prAddAvaliacao (
	IN newDate DATE,
    IN newAvaliacao DOUBLE,
    IN newComentario VARCHAR(250),
    IN newCliente INT,
    IN newWorkshop INT,
    OUT prResultado VARCHAR(150)
    )
prAddAvaliacao:BEGIN
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS;
                ROLLBACK;
            END;
            
    -- Defini-se o início das transações.        
	START TRANSACTION;
    
    -- Confirma-se que o Cliente existe na tabela Cliente.
    -- Caso não exista é abortado a inserção de quaisquer dados, é dado um valor a prResultado que indica o erro e 
    -- sai-se do procedimento.
    IF (SELECT COUNT(*) FROM Cliente WHERE Cliente.ID = newCliente) = 0 THEN
		ROLLBACK;
        SET prResultado = "O Cliente fornecido não existe.";
        LEAVE prAddAvaliacao;
    END IF;
    
    -- Confirma-se que a Workshop existe na tabela Workshop.
    -- Caso não exista é abortado a inserção de quaisquer dados, é dado um valor a prResultado que indica o erro e 
    -- sai-se do procedimento.
    IF (SELECT COUNT(*) FROM Workshop WHERE Workshop.ID = newWorkshop) = 0 THEN
		ROLLBACK;
        SET prResultado = "A Workshop fornecida não existe.";
        LEAVE prAddAvaliacao;
    END IF;
    
    -- Confirma-se que o Cliente fornecido não tem uma Avaliacao associada à Workshop fornecida.
    -- Caso tenha é abortada a inserção de quaisquer dados, é dado um valor a prResultado que indica o erro e 
    -- sai-se do procedimento.
    IF (SELECT COUNT(*) FROM Avaliacao WHERE Avaliacao.Cliente = newCliente AND Avaliacao.Workshop = newWorkshop) > 0 THEN
		ROLLBACK;
        SET prResultado = "O Cliente já tem uma avaliação na Workshop fornecida.";
        LEAVE prAddAvaliacao;
	END IF;
    
    -- Confirma-se que a Avaliacao fornecida encontra-se dentro do intervalo [1-5].
    -- Caso não esteja é abortada a inserção de quaisquer dados, é dado um valor a prResultado que indica o erro e
    -- sai-se do procedimento.
    IF newAvaliacao > 5 OR newAvaliacao < 1 THEN
		ROLLBACK;
        SET prResultado = "A Avaliação fornecida não se encontra dentro do intervalo [1-5].";
        LEAVE prAddAvaliacao;
	END IF;
    
    -- Inserção da Avalição na tabela Avaliacao.
    INSERT INTO Avaliacao
		(DataOmissao, AvaliacaoQuantitativa, Comentario, Cliente, Workshop)
			VALUES
				(newDate, newAvaliacao, newComentario, newCliente, newWorkshop);
                
                
    -- Usa-se a função COMMIT para indicar a finalização de todas as transações e dá-se um valor a prResultado para indicar 
    -- o sucesso do procedimento.
    COMMIT;
    SET prResultado = "Avaliação adicionado com sucesso.";
    
END
$$



DELIMITER $$
CREATE PROCEDURE prAddCliente(
	IN newNIF INT,
    IN newNome VARCHAR(75),
    IN newEmail VARCHAR(100),
	IN newSexo CHAR(1),
    IN newDataNascimento DATE,
    OUT prResultado VARCHAR(150)
    )
prAddCliente:BEGIN

	-- Inicia-se o tratamento de erros.
    -- Aquando um erro é então  o erro e é usada a função ROLLBACK para reverter quaisquer inserções ou modificações feitas a alguma tabela-
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS;
            ROLLBACK;
		END;
        -- Define-se o início das transações.
        START TRANSACTION;
        
        -- Confirma-se se o Cliente existe na tabela Cliente.
		-- Caso exista é abortada a inserção de quaisquer dados, é dado um valor a prResultado que indica o erro e sai-se do procedimento.
        IF (SELECT COUNT(*) FROM Cliente WHERE Cliente.NIF = newNIF) > 0 THEN
			ROLLBACK;
            SET prResultado = "Cliente fornecido já existe!";
            LEAVE prAddCliente;
		END IF;
        -- Inserção do Cliente na tabela Cliente.
        INSERT INTO Cliente
			(NIF, Nome, Email, Sexo, DataNascimento)
				VALUES
					(newNIF, newNome, newEmail, newSexo, newDataNascimento);
                
		-- Usa-se a função COMMIT para indicar a finalização de todas as transações e dá-se um valor a prResultado para indicar o sucesso do procedimento.
		COMMIT;
        SET prResultado = "Cliente adicionado.";
END
$$
#DROP PROCEDURE prAddCliente;
    


DELIMITER $$
CREATE PROCEDURE prAddEmpresa(
	IN newNIF INT,
    IN newNome VARCHAR(75),
    IN newSetor VARCHAR(50),
    IN newTelemovel VARCHAR(20),
    IN newEmail VARCHAR(100),
    OUT prResultado VARCHAR(150)
    )
prAddEmpresa:BEGIN

	-- Inicia-se o tratamento de erros.
    -- Aquando um erro é então  o erro e é usada a função ROLLBACK para reverter quaisquer inserções ou modificações feitas a alguma tabela-
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS;
            ROLLBACK;
		END;
        
        -- Defini-se o início das transações.
        START TRANSACTION;
        
        
        -- Confirma-se se a Empresa existe na tabela Empresa.
		-- Caso exista é abortada a inserção de quaisquer dados, é dado um valor a prResultado que indica o erro e sai-se do procedimento.
        IF (SELECT COUNT(*) FROM Empresa WHERE Empresa.NIF = newNIF) > 0 THEN
			ROLLBACK;
            SET prResultado = "Empresa fornecida já existe!";
            LEAVE prAddEmpresa;
		END IF;
        
        -- Inserção da Empresa na tabela Empresa.
        INSERT INTO Empresa
			(NIF, Nome, Setor, Telemovel, Email)
				VALUES
					(newNIF, newNome, newSetor, newTelemovel, newEmail);
                
                
		-- Usa-se a função COMMIT para indicar a finalização de todas as transações e dá-se um valor a prResultado para indicar o sucesso do procedimento.
		COMMIT;
        SET prResultado = "Empresa adicionada.";
        
END
$$
#DROP PROCEDURE prAddEmpresa;



DELIMITER $$
CREATE PROCEDURE prCreateWorkshop(
	IN newNome VARCHAR(75),
    IN newData DATE,
    IN newDuracao TIME,
    IN newGastos DECIMAL(8,2),
    IN newMorada VARCHAR(75),
    IN newCodigoPostal VARCHAR(20),
    OUT prResultado VARCHAR(150)
    )
prCreateWorkshop:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS;
            ROLLBACK;
		END;
        
	IF (SELECT COUNT(*) FROM Workshop WHERE Workshop.Data = newData) > 0 THEN
		ROLLBACK;
        SET prResultado = "Uma Workshop já irá decorrer nesta data.";
        LEAVE prCreateWorkshop;
	END IF;
    
    INSERT INTO Workshop
		(Nome, Data, Duracao, Gastos, Morada, CodigoPostal)
			VALUES
				(newNome, newData, newDuracao, newGastos, newMorada, newCodigoPostal);
		
    COMMIT;
    SET prResultado = "Workshop criada.";

END
$$
#DROP PROCEDURE prCreateWorkshop;



DELIMITER $$
CREATE PROCEDURE prAddEmpresaToWorkshop(
	IN newEmpresaID INT,
    IN newWorkshopID INT,
    IN newPreco DECIMAL(8,2),
    OUT prResultado VARCHAR(150)
    )
prEmpresaParticipates:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS;
            ROLLBACK;
		END;

	IF (SELECT COUNT(*) FROM Workshop WHERE Workshop.ID = newWorkshopID) = 0 THEN
		ROLLBACK;
        SET prResultado = "A Workshop fornecida não existe.";
        LEAVE prEmpresaParticipates;
    END IF;
    
    IF (SELECT COUNT(*) FROM Empresa WHERE Empresa.ID = newEmpresaID) = 0 THEN
		ROLLBACK;
        SET prResultado = "A Empresa fornecida não existe.";
        LEAVE prEmpresaParticipates;
    END IF;
    
    IF (SELECT COUNT(*) FROM EmpresaWorkshop AS EW WHERE EW.Empresa = newEmpresaID AND EW.Workshop = NewWorkshopID) > 0 THEN
		ROLLBACK;
        SET prResultado = "A Empresa já participa neste Workshop.";
        LEAVE prEmpresaParticipates;
    END IF;
    
    INSERT INTO EmpresaWorkshop
		(Empresa, Workshop, Preco)
			VALUES
				(newEmpresaID, newWorkshopID, newPreco);
                
	
    COMMIT;
    SET prResultado = "Empresa adicionada ao conjunto de Empresas que participam.";

END
$$
#DROP PROCEDURE prEmpresaParticipates;



DELIMITER $$
CREATE PROCEDURE prEmpresaInterestsCliente(
	IN newEmpresa INT,
    IN newCliente INT,
    OUT prResultado VARCHAR(150)
    )
prEmpresaInterestsCliente:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS;
            ROLLBACK;
		END;
        
	IF (SELECT COUNT(*) FROM Empresa WHERE Empresa.ID = newEmpresa) = 0 THEN
		ROLLBACK;
        SET prResultado = "Empresa fornecida não existe.";
        LEAVE prEmpresaInterestsCliente;
    END IF;
    
    IF (SELECT COUNT(*) FROM Cliente WHERE Cliente.ID = newCliente) = 0 THEN
		ROLLBACK;
        SET prResultado = "Cliente fornecido não existe.";
        LEAVE prEmpresaInterestsCliente;
    END IF;
    
    IF (SELECT COUNT(*) FROM EmpresaCliente AS EC WHERE EC.Cliente = newCliente AND EC.Empresa = newEmpresa) > 0 THEN
		ROLLBACK;
        SET prResultado = "Empresa já interessou Cliente.";
        LEAVE prEmpresaInterestsCliente;
    END IF;
    
    INSERT INTO EmpresaCliente
		(Empresa,Cliente)
			VALUES
				(newEmpresa, newCliente);
    
    COMMIT;
    SET prResultado = "Empresa adicionada ao conjunto de Empresas que interessam o Cliente.";
    
END
$$


#RM4 - O sistema de base de dados deve ser capaz de, dado o ID de um Cliente retornar as Inscrições que fizeram.
DELIMITER $$
CREATE PROCEDURE prGetInscricoes(
	IN ClienteID INT,
    OUT prResultado VARCHAR(100)
	)
prGetInscricoes:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS;
		END;
	IF (SELECT COUNT(*) FROM cliente WHERE cliente.ID = ClienteID) = 0 THEN
		ROLLBACK;
        SET prResultado = "O cliente fornecido não existe.";
        LEAVE prGetInscricoes;
    END IF;
	SELECT ID, Cliente, Workshop, DataInscricao AS "Data de Inscrição", Preco AS "Preço"
		FROM Inscricao
        WHERE Inscricao.Cliente = ClienteID;
END
$$

#RM5 - O sistema de base de dados deve retornar todas as críticas de um Workshop.
DELIMITER $$
CREATE PROCEDURE prGetCriticas(
	IN WorkshopID INT,
    OUT prResultado VARCHAR(100)
)
prGetCriticas: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS;
		END;
	
    IF (SELECT COUNT(*) FROM Workshop WHERE Workshop.ID = WorkshopID) = 0 THEN
		ROLLBACK;
        SET prResultado = "O Workshop fornecido não existe.";
        LEAVE prGetCriticas;
    END IF;
    
    SELECT W.Nome AS "Workshop", A.Comentario FROM workshop AS W
		INNER JOIN avaliacao AS A
			ON W.id = A.Workshop
            WHERE W.Id = WorkshopID;
	
    COMMIT;
    SET prResultado = "Comentários dados nas avaliações do workshop:";
    
END
$$
#CALL prGetCriticas(3,@a)

DELIMITER $$
CREATE PROCEDURE prGetAvaliacoes(
	IN WorkshopID INT,
    OUT prResultado VARCHAR(100)
	)
prGetAvaliacoes:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SHOW ERRORS;
		END;
        
	IF (SELECT COUNT(*) FROM Workshop WHERE Workshop.ID = WorkshopID) = 0 THEN
		ROLLBACK;
        SET prResultado = "O Workshop fornecido não existe.";
        LEAVE prGetAvaliacoes;
    END IF;
            
	SELECT ID, Cliente, Workshop, DataOmissao AS "Data de Omissão", AvaliacaoQuantitativa AS "Avaliação", Comentario AS "Comentário"
		FROM Avaliacao
        WHERE Avaliacao.Workshop = WorkshopID;
        
END
$$

#RM9 - Dado um local, o sistema deve dar todos os Workshops onde lá se fizeram.
DELIMITER $$
CREATE PROCEDURE prGetWorkshopByLocation(
	IN newMorada VARCHAR(75),
    IN newCodigoPostal VARCHAR(20)
    )
prGetWorkshopByLocation:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS;
			END;
            
	SELECT ID, Nome, Duracao AS "Duração", AvaliacaoQuantitativa AS "Avaliação Quantitativa", Morada, CodigoPostal AS "Código Postal", Gastos
		FROM Workshop
        WHERE Workshop.Morada = newMorada AND Workshop.CodigoPostal = newCodigoPostal;
END
$$


#RM12 - Dado um mês, o sistema deve imprimir todas as inscrições feitas neste mês.
DELIMITER $$
CREATE PROCEDURE prGetInscricoesByMonth(
	IN newDataInscricao DATE
    )
prGetInscricoesByMonth:BEGIN
	
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SHOW ERRORS;
			END;
            
	SELECT ID, Cliente, Workshop, DataInscricao AS "Data de Inscrição", Preco AS "Preço" 
		FROM Inscricao
        WHERE DATE_FORMAT(Inscricao.DataInscricao, "%m") = DATE_FORMAT(newDataInscricao, "%m");

END
$$
