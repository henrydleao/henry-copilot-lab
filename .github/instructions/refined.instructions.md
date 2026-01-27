---
applyTo: "**/*.{py,sql}"
---

# Norma – Camada REFINED no Data Lakehouse com Databricks (para code review)

Este prompt contém somente itens do texto da norma REFINED que são **verificáveis no code review** (nomenclatura e sintaxes).

## 1) Nomenclatura geral

Deve utilizar:
- letras minúsculas
- no singular
- sem acentuação
- sem caractere especial
- símbolo "_" como separador de palavras
- sem preposição
- sem artigo
- sem pronome
- sem interjeição
- sem conjunção
- abreviação somente para termos de conhecimento amplo na sociedade ou pelo negócio¹

Importante:
- ¹ Alinhamento com Governança de Dados para inclusão do termo na planilha de definição de siglas e termos.

## 2) Esquema

Sintaxe: `<domínio-de-dados>`

Exemplos:
- Juridico
- Regulacao
- operacao

## 3) Tabela

Sintaxe: `tb_<tipo-lógico-tb-refined>_<finalidade-tb>`

Exemplos:
- tb_emd_regressao
- tb_smd_regressao
- tb_vis_fornecedor_insumo_quimico
- tb_360_cliente

Parâmetro `<tipo-lógico-tb-refined>` (valores):
- `emd` – Entrada para o modelo de Machine Learning
- `smd` – Saída do modelo de Machine Learning
- `vis` – Visão de negócio (painel e relatório conectam-se nesse tipo de tabela)
- `360` – Visão 360º de negócio

Parâmetro `<finalidade-tb>`:
- Texto livre com foco em identificar a tabela tratada
- Não é recomendado abreviar palavras; abreviar somente termos amplamente conhecidos (ex.: cpf) ou de uso comum ao negócio (planilha de termos e siglas)

## 4) Coluna

Sintaxe: `<tipo-lógico-coluna>[_<complemento_estrutura_complexa>]_<finalidade-coluna>`

Exemplos:
- qtd_quantidade_hidrometro
- qtd_valor_conta_faturada
- num_cpf
- num_telefone (no banco o tipo é string, mas o conteúdo é convencionalmente número)
- num_flag_instalacao_ativa (conteúdo é 0 ou 1)
- txt_flag_instalacao_ativa (conteúdo do campo é “sim”/”não” ou “S”/”N”)
- txt_endereco_cliente
- est_json_hidrometro_inteligente
- dat_pagamento

Parâmetro `<tipo-lógico-coluna>`:

Os tipos lógicos abaixo representam o conteúdo do dado de uma coluna, e não o tipo em si da coluna (data type):
- `num` – Número Qualitativo
  - Tipos numéricos: TINYINT, SMALLINT, INT, BIGINT, FLOAT, DOUBLE, DECIMAL
  - Tipo de texto que representa um número qualitativo: STRING
- `qtd` – Número Quantitativo
  - Tipos numéricos: TINYINT, SMALLINT, INT, BIGINT, FLOAT, DOUBLE, DECIMAL
- `txt` – Texto
  - Tipo de texto: STRING
  - Tipo booleano: BOOLEAN
- `est` – Estrutura Complexa
  - Tipos de estrutura complexa: ARRAY, MAP, STRUCT, VARIANT, OBJECT
- `dat` – Data
  - Tipos de data: DATE, TIMESTAMP, TIMESTAMP_NTZ, INTERVAL

Parâmetro `<complemento_estrutura_complexa>` (opcional):
- Somente utilizar quando o tipo lógico da coluna for de Estrutura Complexa (`est`)
- Coloque a extensão ou um texto que identifique qual o tipo da estrutura complexa (json, xml, etc)

Exemplos:
- est_json_hidrometro_inteligente
- est_xml_hidrometro_inteligente

Parâmetro `<finalidade-coluna>`:
- Texto livre com foco em identificar o objetivo da coluna tratada
- Não é recomendado abreviar palavras; abreviar somente termos amplamente conhecidos (ex.: cpf) ou de uso comum ao negócio (planilha de termos e siglas)

## 5) Origem dos dados na camada

- Camada TRUSTED
- Camada REFINED

## 6) Destino dos dados da camada

- Camada REFINED


