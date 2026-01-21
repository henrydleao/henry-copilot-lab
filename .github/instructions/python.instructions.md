---
applyTo: "**/*.py"
---

# Regras para arquivos Python (.py) – Engenharia de Dados

Estas instruções se aplicam a **qualquer** arquivo `*.py` do repositório. O Copilot deve **priorizar segurança, governança e manutenibilidade**, seguindo as regras abaixo.

## 1) Cabeçalho obrigatório

Todo arquivo Python relevante **deve iniciar** com o cabeçalho:

```text
# Autor: <Nome>
# Data: <YYYY-MM-DD>
# Projeto: <NomeDoProjeto>
# Camada: <Bronze|Trusted|Refined|Outro>
# Tabela: <nome_da_tabela_ou_N/A>
# Objetivo: <descrição sucinta>
# Versão: <x.y.z>
# Histórico: <resumo de mudanças>
```

Se ausente, sugerir inclusão.

## 2) Segredos e configuração

**Nunca** hardcode credenciais, tokens ou segredos em código.
Usar **SCOPE/secret management** e/ou variáveis de ambiente seguras.
Se detectar password=, tokens ou chaves literais: **alertar** e **sugerir** dbutils.secrets (ou equivalente).

## 3) Contratos e validação de dados (App Files)

Quando o arquivo fizer parte de **App Files, confirmar** o uso de **Pandera** em app_file/schemas/<arquivo>.py.
Sugerir criação/ajuste de **schema Pandera** quando houver transformações sem validação (tipos, faixas, padrões, obrigatoriedade).

## 4) Schema explícito em Spark

Evitar inferência silenciosa; **definir StructType/StructField** com **comentários por coluna** quando trabalhar com Spark.
Garantir coerência de tipos antes de persistir.

## 5) Camadas Trusted/Refined e DLT

Se o código for para src/dlt/<trusted|refined>/..., **usar DLT** (Delta Live Tables) em vez de jobs Spark “puros”.
Se detectar processamento dessas camadas sem DLT: **sugerir migração** para DLT.

## 6) Catálogos, paths e clusterização

**Não** usar catálogos/paths hardcoded. **Parametrizar** (variáveis/config).
Validar **clusterização/otimização** (ex.: Z-ORDER) quando aplicável ao volume/padrão de acesso.

## 7) Logging e prints

Prefira o **logger do projeto** a print.
Mensagens devem ser claras e úteis para troubleshooting.

## 8) Revisão rápida (checklist para PR)

Cabeçalho presente e completo?
Sem segredos hardcoded?
Pandera aplicado (quando App Files)?
Schema explícito (StructType + comentários) quando Spark?
DLT usado em trusted/refined?
Sem catálogos/paths hardcoded?
Logging adequado?

## 9) Anti‑padrões que o Copilot não deve sugerir

Hardcode de segredos, catálogos ou caminhos absolutos.
Transformações de trusted/refined **sem DLT**.
Inferência de schema sem validação/contrato.
Arquivos sem cabeçalho obrigatório.