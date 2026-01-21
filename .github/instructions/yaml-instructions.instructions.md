
---
applyTo: "**/*.yml,**/*.yaml"
---

# Regras para arquivos YAML (.yml/.yaml) – Pipelines e Jobs

Estas instruções se aplicam a **qualquer** arquivo YAML do repositório, com foco em `resources/`.

## 1) Nomenclatura e localização
- **Pipelines**: `resources/dlt_<processo>.pipeline.yml`
- **Jobs**: `resources/job_<processo>.job.yml`

Se o nome não seguir o padrão, **sugerir renomear**.

## 2) Pipelines (DLT)
- Garantir que a pipeline **use DLT** para camadas `trusted/refined`.
- **Usar variáveis de catálogo** (nada hardcoded).
- **Paths relativos** para notebooks/artefatos (evitar `/Workspace`/`/Repos` absolutos).
- Verificar **estrutura consistente** (tasks bem definidas, dependências claras).
- Validar **indentação** e **chaves** (YAML parseável).

## 3) Jobs
- Estrutura **mínima obrigatória**:
  - `schedule` (cron/frequência coerente)
  - `tasks` (com dependências quando houver)
  - `webhook` (notificações/observabilidade)
  - `permissions` (execução/ACLs)
- Não misturar sintaxe de **outras ferramentas** (ex.: GitHub Actions) dentro dos arquivos de job/pipeline.

## 4) Parametrização e segurança
- **Não** usar catálogos/paths literais: parametrizar tudo que for ambiente/catalogação.
- **Segredos** sempre via mecanismo apropriado (nunca em texto claro no YAML).

## 5) Revisão rápida (checklist para PR)
- Nome e diretório seguem o padrão?
- YAML **válido** (indentação, chaves, listas)?
- Para pipelines: DLT aplicado, paths relativos, variáveis de catálogo?
- Para jobs: `schedule`, `tasks`, `webhook`, `permissions` presentes?
- Nada de caminhos absolutos ou credenciais expostas?

## 6) Anti‑padrões que o Copilot **não deve** sugerir
- Caminhos absolutos (`/Workspace/...`, `/Repos/...`).
- Catálogos/paths/segredos **hardcoded**.
- Jobs sem `schedule`/`tasks`/`webhook`/`permissions`.
- Pipelines de `trusted/refined` sem DLT.
- YAML inválido (indentação/quebra de chaves).
``
