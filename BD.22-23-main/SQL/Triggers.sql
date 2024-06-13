USE IndustryInsight;
#DROP DATABASE IndustryInsight;

# RM7 - Deve ser possível mostrar a média de avaliações num determinado Workshop.
-- Trigger que mantém a Avaliação Quantitativa de um Workshop atualizada com a média de todas as Avaliações desse mesmo. RD19
DELIMITER $$
CREATE TRIGGER trUpdateAvaliacaoWorkshop
	AFTER INSERT ON Avaliacao
    FOR EACH ROW
BEGIN

	-- Atualiza o valor de AvaliacaoQuantitativa da tabela Workshop com a nova média de todas as Avaliações para essa Workshop.
	UPDATE Workshop
		SET AvaliacaoQuantitativa = (SELECT AVG(AvaliacaoQuantitativa) FROM Avaliacao WHERE Avaliacao.Workshop = NEW.Workshop)
        WHERE Workshop.ID = NEW.Workshop;
        
END
$$