---
applyTo: "**/*.{py,sql}"
---

# Norma – Marcador de Dados (Tag) no Databricks

Estas instruções consolidam as **regras de marcadores de dados (tags)** no Databricks.

## 1) Marcador de dados (tag)

Deve:
- Ter um nome que identifique a finalidade da tag
- Separar os dados em categorias previamente especificadas
- Conter informações que proporcionem o entendimento dos dados

## 2) Nomenclatura dos marcadores (nome da tag)

Deve utilizar:
- Língua inglesa
- Letras maiúsculas para a primeira letra de cada palavra
- Letras minúsculas para todas as palavras com exceção da primeira letra de cada palavra
- No singular
- Sem acentuação
- Sem caractere especial
- Sem espaço entre palavras
- Sem preposição
- Sem artigo
- Sem pronome
- Sem interjeição
- Sem conjunção

## 3) Tags no Databricks

As tags no Databricks são:
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
- Língua portuguesa¹
- Letras minúsculas
- No singular²
- Sem acentuação
- Sem caractere especial
- Símbolo "_" como separador de palavras
- Abreviação somente para termos de conhecimento amplo na sociedade ou pelo negócio³
- Sem preposição
- Sem artigo
- Sem pronome
- Sem interjeição
- Sem conjunção

Importante:
- ¹ Exceção para nome de time dentro de Data Analytics & AI
- ² Não deve ser aplicado para domínio de dados ou nome de time em Data Analytics & AI
- ³ Alinhamento com Governança de Dados para inclusão do termo na planilha de definição de siglas e termos

## 5) Regras por tag

### 5.1) Application

O conteúdo do marcador (tag) deve identificar a núvem do Databricks.

Valores permitidos:
- `adb` (Azure Databricks)
- `gdb` (Google Databricks)
- `wdb` (AWS Databricks)

### 5.2) Confidentiality

O conteúdo do marcador (tag) deve identificar o nível de confidencialidade do dado.

Valores permitidos:
- `publico`
- `interno`
- `restrito`
- `confidencial`

### 5.3) Cluster

O conteúdo do marcador deve identificar:
1) Se a tabela possui cluster ou não
2) Se a coluna faz parte de um cluster ou não

Valores permitidos:
- `sim`
- `nao`

### 5.4) DataAnalyticsTeam

O conteúdo do marcador (tag) deve identificar qual o time de Data Analytics & AI é responsável pelo esquema da camada de sandbox dentro do ambiente de exploração e experimentação de dados.

Valores permitidos:
- `arquitetura_dados`
- `ciencia_dados`
- `digital_factory`
- `engenharia_dados`
- `governanca_dados`
- `hiperautomacao`

### 5.5) DataDomain

O conteúdo do marcador (tag) deve identificar qual o domínio de dados que o objeto está relacionado.

Valores permitidos:
- `auditoria_interna`
- `comunicacao`
- `dados_referenciais`
- `energia_eletrica`
- `engenharia`
- `estrategia_corporativa`
- `experiencia_cliente`
- `faturamento`
- `financeiro`
- `gente_gestao`
- `juridico`
- `logistica`
- `observabilidade_dados`
- `observabilidade_ti`
- `operacao_agua`
- `operacao_esgoto`
- `operacao_estrategica`
- `patrimonio`
- `protecao_receita`
- `regulacao`
- `servicos_compartilhados`
- `suprimentos`
- `sustentabilidade`

### 5.6) DataLayer

O conteúdo do marcador (tag) deve identificar a camada lógica dos dados do data lakehouse que o objeto está associado.

Camadas lógicas e valores permitidos:
- `sbx` (Camada de dado exploratório - sandbox)
- `stg` (Camada de dado temporário - staging)
- `raw` (Camada de dado bruto - raw)
- `tru` (Camada de dado confiável - trusted)
- `ref` (Camada de dado refinado - refined)
- `aud` (Camada de dado para auditoria - audit)

### 5.7) Environment

O conteúdo do marcador (tag) deve identificar o tipo de ambiente de dados no qual o objeto está localizado.

Ambientes e valores permitidos:
- `sbd` (Sandbox)
- `dev` (Desenvolvimento)
- `hml` (Homologação)
- `prd` (Produção)

### 5.8) QualityCertificate

O conteúdo do marcador (tag) deve identificar o nível do certificado de qualidade dos dados no objeto associado.

Valores permitidos:
- `nao_certificado`
- `bronze`
- `prata`
- `ouro`

### 5.9) Partition

O conteúdo do marcador (tag) deve identificar:
1) Se a tabela possui particionamento ou não
2) Se a coluna faz parte de um particionamento ou não

Valores permitidos:
- `sim`
- `nao`

### 5.10) PK

O conteúdo do marcador (tag) deve identificar se a coluna faz parte de uma chave única ou não, ou seja, identifica um único registro na tabela.

Valores permitidos:
- `sim`
- `nao`

### 5.11) Privacy

O conteúdo do marcador (tag) deve identificar se a tabela ou a coluna possuem dados de privacidade.

Valores permitidos:
- `nao_pessoal`
- `pessoal`
- `pessoal_sensivel`

### 5.12) UpdateFrequency

O conteúdo do marcador (tag) deve identificar a frequência que um objeto é atualizado.

Valores permitidos:
- `diario`
- `semanal`
- `quinzenal`
- `mensal`
- `bimestral`
- `trimestral`
- `quadrimestral`
- `semestral`
- `anual`
- `sob_demanda`

### 5.13) LoadType

O conteúdo do marcador (tag) deve identificar o tipo de carga utilizada para criar ou atualizar uma tabela.

Valores permitidos:
- `completa`
- `incremental`

### 5.14) DataFlowTechnology

O conteúdo do marcador (tag) deve identificar o tipo de tecnologia empregada no fluxo do processo execucional dos dados dentro do Databricks para executar jobs e/ou pipelines.

Valores permitidos:
- `notebook_orquestrador`
- `lakeflow_connect`
- `delta_sharing`

### 5.15) DataFlowName

O conteúdo do marcador (tag) deve identificar o nome do job e/ou pipeline referente ao fluxo do processo de execução.

Regra:
- Não existe valores pré-definidos; é necessário escrever o nome do processo de job ou pipeline que é executado

## 6) Conformidade

O não cumprimento desta norma está sujeito a medidas disciplinares conforme regulamento interno.

