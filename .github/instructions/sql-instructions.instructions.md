---
applyTo: "**/*.sql"
---

# Regras para arquivos SQL (.sql) – Engenharia de Dados

Estas instruções se aplicam a **qualquer** arquivo `*.sql` do repositório. O Copilot deve reforçar governança, estrutura e segurança.

## 1) Localização e controle (App Files)
- Arquivos SQL manuais devem estar em `app_file/sql/<nome_arquivo>.sql`.
- Garantir/atualizar o **registro** em `dev_stg_adls.app_files.tb_controle` quando aplicável (incluir instruções/documentação necessárias).

## 2) Catálogos/paths e parametrização
- **Evitar** literais de catálogo e caminhos absolutos.
- **Usar variáveis/parametrização** definidas pelo projeto (catálogo, schema, localização).

## 3) Camadas e fluxo de dados
- Respeitar **bronze → trusted → refined**.
- Não “pular” etapas (ex.: criar refined direto a partir de bronze).
- Transformações de `trusted/refined` devem ser executadas via **DLT** (mover lógica para pipeline se estiver em SQL “solto”).

## 4) Qualidade de SQL
- **Proibir `SELECT *`** em consultas persistentes (listar colunas explicitamente).
- Definir **tipos e constraints** coerentes ao criar tabelas/visões.
- **Comentar** colunas e tabelas (descrições claras).
- Cuidado com joins: **definir chaves** e evitar duplicações (ex.: usar `JOIN ... ON ...` correto e, quando necessário, técnicas de deduplicação).

## 5) Segurança e operações perigosas
- **Sinalizar** `DELETE` sem `WHERE` ou atualizações amplas sem salvaguardas.
- Verificar **exposição de dados sensíveis** e mascaramento quando necessário.

## 6) Ativos, tags e metadados
- Toda **tabela** deve possuir metadados coerentes.
- Garantir que existam notebooks `tags_<tabela>.ipynb` com **tags mínimas exigidas** (6 em colunas, 2 na tabela) e descrições alinhadas.

## 7) Revisão rápida (checklist para PR)
- Arquivo em `app_file/sql/...`?
- Registro/atualização em `tb_controle`?
- Sem `SELECT *`? Colunas explícitas e tipos corretos?
- Sem catálogos/paths hardcoded?
- Respeito a bronze → trusted → refined (DLT para trusted/refined)?
- Comentários/descrições de colunas/tabela?
- Riscos de `DELETE`/`UPDATE` massivo controlados?

## 8) Anti‑padrões que o Copilot **não deve** sugerir
- `SELECT *` em artefatos persistentes.
- Tabelas sem comentários/metadados.
- `DELETE` sem `WHERE`.
- Refined direto de bronze (sem trusted/DLT).
- Catálogos/paths hardcoded.