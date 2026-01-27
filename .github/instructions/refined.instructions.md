---
applyTo: "**/*.{py,sql}"
---

# Norma – Camada Refined no Data Lakehouse com Databricks

Estas instruções consolidam as **regras da camada REFINED**.

## 1) Camada refinada (REFINED)

Deve:
- Ser a camada de origem para produtos de dados do tipo base relacional, machine learning, e visualização
- Ser organizada por domínio de dados em conjunto com uma necessidade específica que pode ser representada dentro do domínio tratado
- Ser utilizada exclusivamente para armazenamento de dados refinados
- Ser considerada a camada de origem dos dados para ativos como painéis e relatórios
- Conter dados aprovados pelo responsável do domínio
- Conter objetos padronizados conforme as normas definidas
- Conter dados validados e otimizados
- Proteger os dados por mascaramento e/ou anonimização
- Proteger os dados por marcadores (tag) que requerem aprovação extra de acesso (lgpd, confidencialidade)
- Proteger os dados através de controle de acesso
- Ter um domínio de dados associado
- Ter os dados orientados por caso de uso
- Ter associado um certificado de qualidade para o consumo dos dados
- Ter como origem de dados a camada TRUSTED e/ou REFINED (importante: cuidado ao utilizar dados da camada refinada como origem, pois podem já conter informações com vieses aplicados para uma necessidade que representa o domínio tratado)
- Ter como destino de dados a camada REFINED
- Ter acesso aprovado pelo responsável pelo domínio de dados para utilização
- Ter o desenvolvimento realizado atualmente pelo time de Data Analytics & AI
- Ter os códigos utilizados versionados no Github
- Existir nos ambientes de dados de desenvolvimento, homologação e produção

## 2) Nomenclatura geral

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

## 6) Acesso

Conforme prévia autorização do responsável pelo domínio associado aos dados nessa camada.

Pode ser acessado por:
- time técnico
- time representante do domínio de dados tratado

## 7) Origem dos dados na camada

- Camada TRUSTED
- Camada REFINED

## 8) Destino dos dados da camada

- Camada REFINED

## 9) Ativo que pode conectar com dados dessa camada

- Tabela
- Modelo de Machine Learning
- Painel (dashboard)
- Relatório (report)

## 10) Tipo produto de dados que pode existir nessa camada

- Base relacional
- Machine Learning
- Visualização

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

## 12) Processos

- Fluxo geral de dados através dos ambientes e das camadas no data lakehouse

## 13) Conformidade

O não cumprimento desta norma está sujeito a medidas disciplinares conforme regulamento interno.

