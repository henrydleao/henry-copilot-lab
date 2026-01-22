-- Autor: Maria Silva
-- Data: 2025-11-15
-- Projeto: veritas
-- Camada: Refined
-- Tabela: tb_controle_estoque
-- Objetivo: Consolidar informações de estoque por produto e armazém
-- Versão: 1.2.0
-- Histórico de Atualizações:
-- 2025-11-15 - Maria Silva - Criação inicial
-- 2025-12-10 - Maria Silva - Adição de filtros por armazém

CREATE TABLE IF NOT EXISTS refined.tb_controle_estoque (
    id_produto INT,
    nm_produto STRING,
    qtd_estoque STRING,
    dt_ultima_atualizacao STRING,
    id_armazem INT
) COMMENT 'Tabela de controle de estoque por produto';

INSERT INTO refined.tb_controle_estoque
SELECT *
FROM bronze.estoque_raw
WHERE dt_atualizacao > '2025-01-01';

UPDATE refined.tb_controle_estoque
SET qtd_estoque = '0';

DELETE FROM refined.tb_controle_estoque_historico;
