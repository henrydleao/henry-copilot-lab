---
applyTo: "**/*.{py,sql,yml,yaml,ipynb}"
---

# Norma – Marcador de Dados (TAG) no Databricks (para code review)

Este prompt contém somente itens do texto da norma de TAGs que são **verificáveis no code review** (nomenclatura, chaves de tags e valores permitidos).

## 1) Marcador de dados (tag)

Deve:
- Ter um nome que identifique a finalidade da tag
- Separar os dados em categorias previamente especificadas
- Conter informações que proporcionem o entendimento dos dados

## 2) Nomenclatura dos marcadores (nome da tag)

Deve utilizar:
- língua inglesa
- letras maiúsculas para a primeira letra de cada palavra
- letras minúsculas para todas as palavras com exceção da primeira letra de cada palavra
- no singular
- sem acentuação
- sem caractere especial
- sem espaço entre palavras
- sem preposição
- sem artigo
- sem pronome
- sem interjeição
- sem conjunção

## 3) Tags no Databricks (chaves permitidas)

- Application
- Confidentiality
- Cluster
- DataAnalyticsTeam
- DataDomain
- DataLayer
- Environment
- QualityCertificate
- Partition
- PK
- Privacy
- UpdateFrequency
- LoadType
- DataFlowTechnology
- DataFlowName

## 4) Nomenclatura do conteúdo dos marcadores (valor da tag)

Deve utilizar:
- língua portuguesa¹
- letras minúsculas
- no singular²
- sem acentuação
- sem caractere especial
- símbolo "_" como separador de palavras
- abreviação somente para termos de conhecimento amplo na sociedade ou pelo negócio³
- sem preposição
- sem artigo
- sem pronome
- sem interjeição
- sem conjunção

Importante:
- ¹ Exceção para nome de time dentro de Data Analytics & AI
- ² Não deve ser aplicado para domínio de dados ou nome de time em Data Analytics & AI
- ³ Alinhamento com Governança de Dados para inclusão do termo na planilha de definição de siglas e termos

## 5) Valores permitidos por tag

### 5.1) Application

O conteúdo do marcador (tag) deve identificar a núvem do Databricks.

Opções de valores:
- adb
- gdb
- wdb

### 5.2) Confidentiality

O conteúdo do marcador (tag) deve identificar o nível de confidencialidade do dado.

Opções de valores:
- publico
- interno
- restrito
- confidencial

### 5.3) Cluster

O conteúdo do marcador deve identificar:
1) Se a tabela possui cluster ou não
2) Se a coluna faz parte de um cluster ou não

Opções de valores:
- sim
- nao

### 5.4) DataAnalyticsTeam

O conteúdo do marcador (tag) deve identificar qual o time de Data Analytics & AI é responsável pelo esquema da camada de sandbox dentro do ambiente de exploração e experimentação de dados.

Opções de valores:
- arquitetura_dados
- ciencia_dados
- digital_factory
- engenharia_dados
- governanca_dados
- hiperautomacao

### 5.5) DataDomain

O conteúdo do marcador (tag) deve identificar qual o domínio de dados que o objeto está relacionado.

Opções de valores:
- auditoria_interna
- comunicacao
- dados_referenciais
- energia_eletrica
- engenharia
- estrategia_corporativa
- experiencia_cliente
- faturamento
- financeiro
- gente_gestao
- juridico
- logistica
- observabilidade_dados
- observabilidade_ti
- operacao_agua
- operacao_esgoto
- operacao_estrategica
- patrimonio
- protecao_receita
- regulacao
- servicos_compartilhados
- suprimentos
- sustentabilidade

### 5.6) DataLayer

O conteúdo do marcador (tag) deve identificar a camada lógica dos dados do data lakehouse que o objeto está associado.

Opções de valores:
- sbx
- stg
- raw
- tru
- ref
- aud

### 5.7) Environment

O conteúdo do marcador (tag) deve identificar o tipo de ambiente de dados no qual o objeto está localizado.

Opções de valores:
- sbd
- dev
- hml
- prd

### 5.8) QualityCertificate

O conteúdo do marcador (tag) deve identificar o nível do certificado de qualidade dos dados no objeto associado.

Opções de valores:
- nao_certificado
- bronze
- prata
- ouro

### 5.9) Partition

O conteúdo do marcador (tag) deve identificar:
1) Se a tabela possui particionamento ou não
2) Se a coluna faz parte de um particionamento ou não

Opções de valores:
- sim
- nao

### 5.10) PK

O conteúdo do marcador (tag) deve identificar se a coluna faz parte de uma chave única ou não, ou seja, identifica um único registro na tabela.

Opções de valores:
- sim
- nao

### 5.11) Privacy

O conteúdo do marcador (tag) deve identificar se a tabela ou a coluna possuem dados de privacidade.

Opções de valores:
- nao_pessoal
- pessoal
- pessoal_sensivel

### 5.12) UpdateFrequency

O conteúdo do marcador (tag) deve identificar a frequência que um objeto é atualizado.

Opções de valores:
- diario
- semanal
- quinzenal
- mensal
- bimestral
- trimestral
- quadrimestral
- semestral
- anual
- sob_demanda

### 5.13) LoadType

O conteúdo do marcador (tag) deve identificar o tipo de carga utilizada para criar ou atualizar uma tabela.

Opções de valores:
- completa
- incremental

### 5.14) DataFlowTechnology

O conteúdo do marcador (tag) deve identificar o tipo de tecnologia empregada no fluxo do processo execucional dos dados dentro do Databricks para executar jobs e/ou pipelines.

Opções de valores:
- notebook_orquestrador
- lakeflow_connect
- delta_sharing

### 5.15) DataFlowName

O conteúdo do marcador (tag) deve identificar o nome do job e/ou pipeline referente ao fluxo do processo de execução.

Regra:
- Não existe valores pré-definidos; é necessário escrever o nome do processo de job ou pipeline que é executado
