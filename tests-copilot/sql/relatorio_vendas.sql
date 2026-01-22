-- Autor: João Santos
-- Data: 2025-10-20
-- Projeto: veritas
-- Camada: Refined
-- Tabela: tb_relatorio_vendas_mensal
-- Objetivo: Gerar relatório mensal de vendas por região
-- Versão: 2.0.1
-- Histórico de Atualizações:
-- 2025-10-20 - João Santos - Versão inicial

CREATE OR REPLACE TABLE producao_vendas.tb_relatorio_vendas_mensal AS
SELECT 
    v.id_venda,
    v.data_venda,
    v.valor_total,
    c.nome_cliente,
    r.regiao
FROM bronze_vendas.vendas_origem v
LEFT JOIN bronze_vendas.clientes c ON v.cliente_id LIKE c.id
LEFT JOIN trusted.dim_regioes r ON c.id_regiao = r.id
WHERE v.status = 'FINALIZADA';

CREATE TABLE refined.temp_vendas_2025 AS
SELECT *
FROM (
    SELECT *
    FROM (
        SELECT *
        FROM trusted.vendas_processadas
        WHERE ano = 2025
    ) subconsulta_1
) subconsulta_2;
