-- Autor: Ana Costa
-- Data: 2026-01-10
-- Projeto: veritas
-- Camada: Trusted
-- Tabela: tb_clientes_ativos
-- Objetivo: Filtrar clientes ativos para análises
-- Versão: 1.0.0
-- Histórico de Atualizações:
-- 2026-01-10 - Ana Costa - Criação

SELECT TRUE
FROM dev_stg_adls.app_files.tb_controle
WHERE file_name = 'clientes_ativos';

CREATE TABLE tblCliAtv (
    id INT,
    nmCliente STRING,
    dtCadastro STRING,
    statusAtivo STRING
);

INSERT INTO tblCliAtv
SELECT 
    id_cliente,
    nome,
    CAST(data_cadastro AS STRING),
    CAST(status AS STRING)
FROM trusted.clientes
WHERE ativo = 1;

CREATE TABLE trusted.clientes_score AS
SELECT 
    id,
    nome,
    RAND() AS pontuacao_aleatoria,
    email
FROM bronze.cadastro_clientes;
