USE IndustryInsight;

#INDICES
#Para empresas
CREATE INDEX iEmpresaNome
	ON empresa (Nome);
    
CREATE INDEX iEmpresaNIF
	ON empresa (NIF);

#ALTER TABLE empresa
#	DROP INDEX iEmpresaNome;
#ALTER TABLE empresa
#	DROP INDEX iEmpresaNIF;
    
#Para Workshops
CREATE INDEX indexWorkshops
	ON workshop (Nome);

#ALTER TABLE workshop
#	DROP INDEX indexWorkshops;
    
#Para avaliações
CREATE INDEX iAvalicoesCliente
	ON avaliacao (Cliente);
    
CREATE INDEX iAvalicoesWorkshop
	ON avaliacao (Workshop);

#ALTER TABLE avaliacao
#	DROP INDEX iAvalicoesCliente;
#ALTER TABLE avaliacao
#	DROP INDEX iAvalicoesWorkshop;
    
SHOW INDEXES FROM empresa;
SHOW INDEXES FROM workshop;
SHOW INDEXES FROM avaliacao;