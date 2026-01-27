---
applyTo: "**/*.{py,sql}"
---

# Regras da Camada REFINED (para code review)

Estas instruções focam somente em regras **verificáveis no código** ao criar/alterar objetos na camada REFINED.

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

## 3) Esquema

Sintaxe: `<domínio-de-dados>`

Exemplos:
- Juridico
- Regulacao
- operacao

## 4) Tabela

Sintaxe: `tb_<tipo-lógico-tb-refined>_<finalidade-tb>`

Exemplos:
- tb_emd_regressao
- tb_smd_regressao
- tb_vis_fornecedor_insumo_quimico
- tb_360_cliente

## 5) Coluna

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

## 6) Origem e destino (quando aplicável ao código)

Se o código declarar explicitamente origem/destino de camada:
- Origem permitida: TRUSTED e/ou REFINED
- Destino permitido: REFINED

## 11) Parâmetros

### 11.1) `<domínio>`

Na planilha de domínios, a coluna com o nome “Assunto” contém o nome dos domínios possíveis.

Utilizado nas sintaxes:
- Esquema

### 11.2) `<domínio-de-dados>`

Na planilha de domínios, a coluna com o nome “Assunto” contém o nome dos domínios possíveis.

Importante: lembre-se que ao trazer o nome do domínio da planilha deve-se aplicar as regras de nomenclatura geral para o Databricks.

Utilizado nas sintaxes:
- Esquema

### 11.3) `<tipo-lógico-tb-refined>`

- `emd` – Entrada para o modelo de Machine Learning
- `smd` – Saída do modelo de Machine Learning
- `vis` – Visão de negócio (painel e relatório conectam-se nesse tipo de tabela)
- `360` – Visão 360º de negócio

Utilizado nas sintaxes:
- Tabela

### 11.4) `<finalidade-tb>`

Texto livre com o foco em identificar a tabela tratada.

Importante: não é recomendado abreviar palavras. Somente utilize abreviações para termos amplamente conhecidos pela sociedade (exemplo: cpf), ou de uso comum ao negócio (deve estar na planilha de termos e siglas).

Utilizado nas sintaxes:
- Tabela

### 11.5) `<tipo-lógico-coluna>`

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

Utilizado nas sintaxes:
- Coluna

### 11.6) `<complemento_estrutura_complexa>` (opcional)

1. Somente utilizar esse parâmetro quando o tipo lógico da coluna for de Estrutura Complexa (`est`).
2. Coloque a extensão ou um texto que identifique qual o tipo da estrutura complexa (json, xml, etc).

Exemplos:
- est_json_hidrometro_inteligente
- est_xml_hidrometro_inteligente

Utilizado nas sintaxes:
- Coluna

### 11.7) `<finalidade-coluna>`

Texto livre com o foco em identificar o objetivo da coluna tratada.

Importante: não é recomendado abreviar palavras. Somente utilize abreviações para termos amplamente conhecidos pela sociedade (exemplo: cpf), ou de uso comum ao negócio (deve estar na planilha de termos e siglas).

Utilizado nas sintaxes:
- Coluna


