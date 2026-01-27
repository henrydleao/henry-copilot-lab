-- Autor: Fulano
-- Objetivo: exemplo de staging-- Data: 2026-01-21
-- Versão: 0.1
-- Histórico de Atualizações:
-- 2026-01-21 - Fulano - criação

CREATE TABLE IF NOT EXISTS tb_stg_faturamento_de_vendas (
  id_cliente STRING,
  qtd_data TIMESTAMP,
  num_valor_total DECIMAL(10,2)
);
-- Projeto: veritas
-- Camada: raw
-- Tabela: tb_stg_faturamento_de_vendas