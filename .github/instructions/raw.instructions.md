---
applyTo: "**/*.{py,sql}"
---

# Norma – Camada RAW no Data Lakehouse com Databricks

Estas instruções consolidam as **regras da camada RAW**.

## 1) Camada bruta (RAW)

Deve:
- Ser utilizada exclusivamente para armazenamento de dados brutos
- Ser o único ponto de entrada de dados sistêmicos com carga completa (full) no data lakehouse
- Ser livre de transformações e tratamentos (dados iguais a origem sistêmica)
- Ser organizada por sistema de origem
- Respeitar a modelagem dos dados da origem
- Respeitar a nomenclatura da tabela e colunas de origem de sistema
- Conter dados aprovados pelo responsável do domínio
- Conter objetos padronizados conforme as normas definidas
- Proteger os dados por mascaramento e/ou anonimização
- Proteger os dados por marcadores (tag) que requerem aprovação extra de acesso (lgpd, confidencialidade)
- Proteger os dados através de controle de acesso
- Ter um domínio de dados associado
- Ter associado um certificado de qualidade para o consumo dos dados
- Ter somente tabela como ativo de dados
- Ter como origem de dados os sistemas (para carga completa)
- Ter como origem de dados a camada STAGING (para carga incremental de sistema e arquivo externo)
- Ter como destino de dados a camada TRUSTED
- Ter acesso aprovado pelo responsável pelo domínio de dados para utilização
- Ter acesso exclusivo para time técnico
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

Sintaxe: `<sistema>[_<modulo-sistema>]`

Exemplos:
- vectora
- conecta_wfm
- sap_ecc_fi

## 4) Tabela

Sintaxe: deve seguir a lógica abaixo:

- Se a origem do dado vem de um sistema, direto ou indireto (STAGING), então manter a nomenclatura da origem.
- Senão o dado vem de um volume na camada STAGING (arquivo externo) e deve usar a sintaxe: `tb_stg_<finalidade-da-tabela>`.

Observação: para origem de dados de sistema não devemos utilizar a nomenclatura geral pois devemos seguir exatamente o nome da tabela como está definido no sistema de origem.

## 5) Coluna

Sintaxe: deve seguir a lógica abaixo:

- Se o dado vem de um sistema, direto ou indireto (STAGING), então manter a nomenclatura da origem.
- Senão utilizar o padrão de sintaxe de coluna das camadas TRUSTED e REFINED.

Observação 1: para origem de dados de sistema não devemos utilizar a nomenclatura geral pois devemos seguir exatamente o nome da coluna como está definido no sistema de origem.

Observação 2: para origem de dados não estruturados ou semiestruturados, será necessário realizar uma estruturação mínima das informações em formato de colunas. Entretanto os dados aninhados devem permanecer aninhados.

## 6) Acesso

Conforme prévia autorização do responsável pelo domínio associado aos dados nessa camada.

Pode ser acessado por:
- time técnico exclusivamente

## 7) Origem dos dados na camada

- Sistema de origem, direto ou indireto (STAGING)
- Arquivo externo na camada temporária (STAGING)

## 8) Destino dos dados da camada

- Camada TRUSTED

## 9) Ativo que pode conectar com dados dessa camada

- Não se aplica

## 10) Tipo produto de dados que pode existir nessa camada

- Não existe

## 11) Parâmetros

### 11.1) `<sistema>`

Nome do sistema de origem dos dados fora do data lakehouse.

Utilizado nas sintaxes:
- Esquema

### 11.2) `<modulo-sistema>` (opcional)

Nome que especifica um módulo do sistema.

Esse parâmetro deve ser utilizado quando os dados que serão ingeridos dentro do data lakehouse precisam ser identificados por módulo do sistema por ser mais específico, ou seja, não é o sistema como um todo.

Utilizado nas sintaxes:
- Esquema

### 11.3) `<finalidade-da-tabela>`

Texto livre com o foco em identificar o objetivo da tabela tratada.

Utilizado nas sintaxes:
- Tabela

## 12) Processos

- Fluxo geral de dados através dos ambientes e das camadas no data lakehouse

## 13) Conformidade

O não cumprimento desta norma está sujeito a medidas disciplinares conforme regulamento interno.
