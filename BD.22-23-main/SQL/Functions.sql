USE IndustryInsight;

-- Função que devolve a soma do Preço de todas as bancadas das Empresas que participam num dado Workshop.
DELIMITER $$
CREATE FUNCTION getProfitFromEmpresas
	(WorkshopID INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
	
    -- Variável que irá conter o valor da soma do Preço de todas as bancadas das Empresas que participam num dado Workshop.
    DECLARE totalProfit INT DEFAULT 0;
    
    -- Encontra-se o valor da soma do Preço de todas as bancadas das Empresas que participam num dado Workshop.
	SELECT SUM(Preco) INTO totalProfit
		FROM EmpresaWorkshop 
        WHERE EmpresaWorkshop.Workshop = WorkshopID;
    
    -- Retorna-se a soma.
    RETURN totalProfit;
END
$$


-- Função que devolve a soma do Preço de todas as Inscriçoes efetuadas num dado Workshop.
DELIMITER $$
CREATE FUNCTION getProfitFromClientes
	(WorkshopID INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
	
    -- Variável que irá conter o valor da soma do Preço de todas as Inscriçoes efetuadas num dado Workshop.
    DECLARE totalProfit INT DEFAULT 0;
    
    -- Encontra-se o valor da soma do Preço de todas as Inscrições num dado Workshop.
    SELECT SUM(Preco) INTO totalProfit
		FROM Inscricao
        WHERE Inscricao.Workshop = WorkshopID;
    
    -- Retorna-se a soma.
    RETURN totalProfit;
END
$$