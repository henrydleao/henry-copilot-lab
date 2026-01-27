---
applyTo: "**/*.{py,sql}"
---

# Norma – Camada TRUSTED no Data Lakehouse com Databricks (para code review)

Estas instruções devem conter somente regras **objetivamente verificáveis no code review** com base no texto da norma da camada TRUSTED.

## 1) Nomenclatura geral

Deve utilizar:
- letras minúsculas
- no singular¹
- sem acentuação
- sem caractere especial
- símbolo "_" como separador de palavras
- sem preposição
- sem artigo
- sem pronome
- sem interjeição
- sem conjunção
- abreviação somente para termos de conhecimento amplo na sociedade ou pelo negócio²

Importante:
- ¹ Exceção para nome de domínio de dados, que pode usar o plural quando o nome do domínio está no plural.
- ² Alinhamento com Governança de Dados para inclusão do termo na planilha de definição de siglas e termos.

## 2) Esquema

Sintaxe: `<domínio>`

Exemplos:
- juridico
- regulacao
- operacao

## 3) Tabela

Sintaxe: `tb_<tipo-lógico-tb-trusted>_<finalidade-tb>`

Exemplos:
- tb_dom_tipo_cliente
- tb_cad_fornecedor
- tb_dim_cliente
- tb_fat_consumo_agua

Parâmetro `<tipo-lógico-tb-trusted>` (valores permitidos):
- `cad` – Cadastro
- `dim` – Dimensão
- `dom` – Domínio
- `mov` – Movimento
- `fat` – Fato

Parâmetro `<finalidade-tb>`:
- Texto livre com foco em identificar o objetivo da tabela tratada
- Não é recomendado abreviar palavras; abreviar somente termos amplamente conhecidos (ex.: cpf) ou de uso comum ao negócio (na planilha de termos e siglas)

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
- Somente utilizar quando o tipo lógico da coluna for Estrutura Complexa (`est`)
- Coloque a extensão ou um texto que identifique qual o tipo da estrutura complexa (json, xml, etc)

Parâmetro `<finalidade-coluna>`:
- Texto livre com foco em identificar o objetivo da coluna tratada
- Não é recomendado abreviar palavras; abreviar somente termos amplamente conhecidos (ex.: cpf) ou de uso comum ao negócio (na planilha de termos e siglas)

## 5) Origem e destino (somente quando explícito no código)

Se o código declarar explicitamente origem/destino de camada:
- Origem permitida: RAW e/ou TRUSTED
- Destino permitido: TRUSTED e/ou REFINED

