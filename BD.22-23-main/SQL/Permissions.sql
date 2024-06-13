-- U S E R S
-- Criação, alteração e remoção de utilizadores.
-- Criação de uma tabela de logs
SET GLOBAL general_log = 'ON';

-- Administradores da base de dados
CREATE USER "devs"@"localhost"
	IDENTIFIED BY "developer";
GRANT ALL PRIVILEGES ON industryinsight.* to "devs"@"localhost";

-- Sr.Miguel
CREATE USER "MiguelHorta"@"localhost"
	IDENTIFIED BY 'passMiguelTorreiraHorta';
GRANT ALL PRIVILEGES ON industryinsight.* to 'MiguelHorta'@'localhost';

-- STAFF
-- Organizadores
CREATE USER "orgs"@"localhost"
	IDENTIFIED BY 'organizer';
GRANT SELECT on industryinsight.vwNrParticipations to "orgs"@"localhost";

-- 2 Gerentes Financeiros
CREATE USER "gerenteFinanceiro"@"localhost"
	IDENTIFIED BY "gereFinanca123"
    WITH
		MAX_USER_CONNECTIONS 2; 
#Consulta de inscrições
GRANT SELECT ON industryinsight.vwRegistrations to "gerenteFinanceiro"@"localhost";
GRANT EXECUTE ON PROCEDURE industryinsight.prGetInscricoes to "gerenteFinanceiro"@"localhost";
#Gestão de gastos
GRANT SELECT, INSERT, UPDATE on industryinsight.workshop to "gerenteFinanceiro"@"localhost";
GRANT EXECUTE ON PROCEDURE industryinsight.prGetWorkshopByLocation To "gerenteFinanceiro"@"localhost";
#Gerir lucros
GRANT SELECT on industryinsight.vwCompanyParticipations to "gerenteFinanceiro"@"localhost";
GRANT EXECUTE ON FUNCTION industryinsight.getProfitFromEmpresas to "gerenteFinanceiro"@"localhost";
GRANT EXECUTE ON FUNCTION industryinsight.getProfitFromClientes to "gerenteFinanceiro"@"localhost";

-- 5 Gerentes de clientes/inscrições
CREATE USER "gerenteInscricoes"@"localhost"
	IDENTIFIED BY "gerenteInscricoes123"
    WITH 
        MAX_USER_CONNECTIONS 5; 
GRANT SELECT ON industryinsight.vwRegistrations to "gerenteInscricoes"@"localhost";
GRANT EXECUTE ON PROCEDURE industryinsight.prGetInscricoes to "gerenteFinanceiro"@"localhost";
GRANT INSERT, UPDATE ON industryinsight.cliente to "gerenteInscricoes"@"localhost";
GRANT INSERT, UPDATE ON industryinsight.inscricao to "gerenteInscricoes"@"localhost";
GRANT EXECUTE ON PROCEDURE industryinsight.prCreateInscricao to "gerenteInscricoes"@"localhost";


-- 3 Representantes de Relações Empresariais
CREATE USER "representanteRE"@"localhost"
	IDENTIFIED BY "RFrepresentante123"
    WITH
		MAX_USER_CONNECTIONS 3;
GRANT SELECT,INSERT,UPDATE ON industryinsight.empresa to "representanteRE"@"localhost";
GRANT SELECT,INSERT,UPDATE ON industryinsight.empresaworkshop to "representanteRE"@"localhost";
GRANT EXECUTE ON PROCEDURE industryinsight.prAddEmpresa to "representanteRE"@"localhost";
GRANT EXECUTE ON PROCEDURE industryinsight.prAddEmpresaToWorkshop to "representanteRE"@"localhost";

-- TRIAL (para funcionários novos)
CREATE USER "trial"@"localhost"
	IDENTIFIED BY "trialUser123"
    WITH
		MAX_QUERIES_PER_HOUR 6
        MAX_UPDATES_PER_HOUR 3;
        
#Todos os funcionários tem permissão para ver os dados (menos os orgs)
GRANT SELECT ON industryinsight.* to "trial"@"localhost";
GRANT SELECT ON industryinsight.* to "representanteRE"@"localhost";
GRANT SELECT ON industryinsight.* to "gerenteInscricoes"@"localhost";
GRANT SELECT ON industryinsight.* to "gerenteFinanceiro"@"localhost";

SHOW GRANTS for "orgs"@"localhost";

SELECT * FROM mysql.user