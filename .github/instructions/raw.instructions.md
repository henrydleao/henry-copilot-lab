---
applyTo: "**/*.{py,sql}"
---

# Regras da Camada RAW (para code review)

Estas instruções focam somente em regras **verificáveis no código** ao criar/alterar objetos na camada RAW.

## 1) Princípios de implementação

- A camada RAW deve ser livre de transformações e tratamentos: dados devem permanecer equivalentes à origem sistêmica.
- Para dados vindos de sistema (direto ou indireto via STAGING), a nomenclatura de tabela e coluna deve manter exatamente a origem.

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

## 6) Origem e destino (quando aplicável ao código)

Se o código declarar explicitamente origem/destino de camada:
- Origem permitida: sistema de origem (direto ou indireto via STAGING) e/ou arquivo externo na camada STAGING
- Destino permitido: TRUSTED

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

