# Checklist de Violações - Testes Copilot

Este documento lista todas as violações intencionais inseridas nos arquivos de teste para validar a capacidade do GitHub Copilot de identificar problemas conforme as regras do repositório.

---

## SQL

### `controle_estoque.sql`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 11 | `qtd_estoque STRING` deveria ser INT/DECIMAL | Tipos inconsistentes | Alta |
| 12 | `dt_ultima_atualizacao STRING` deveria ser TIMESTAMP | Tipos inconsistentes | Alta |
| 17-19 | `SELECT *` em query persistente | Proibir SELECT * | Crítica |
| 17 | Bronze → Refined direto (pula Trusted) | Respeitar bronze→trusted→refined | Crítica |
| 21-22 | `UPDATE` sem `WHERE` específico (afeta todas as linhas) | Operação perigosa | Crítica |
| 24 | `DELETE` sem `WHERE` | Operação perigosa | Crítica |

**Total: 6 violações**

---

### `relatorio_vendas.sql`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 10 | `producao_vendas` - catálogo hardcoded | Não usar catálogos hardcoded | Crítica |
| 16 | Bronze → Refined direto (pula Trusted) | Respeitar bronze→trusted→refined | Crítica |
| 17 | `JOIN ... ON ... LIKE` - operador incorreto para join | Joins devem usar = | Alta |
| 22 | Nome de tabela `temp_vendas_2025` - prefixo temporário | Nomes claros e padronizados | Média |
| 23-31 | Queries aninhadas excessivamente (3 níveis) | Evitar complexidade desnecessária | Média |

**Total: 5 violações**

---

### `clientes_ativos.sql`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 13 | `tblCliAtv` - nome opaco/abreviado | Nomes claros e padronizados | Média |
| 13-18 | Tabela criada sem comentários/descrições | Comentar colunas e tabelas | Alta |
| 14-15 | `dtCadastro STRING`, `statusAtivo STRING` - tipos errados | Tipos inconsistentes | Alta |
| 22-23 | `CAST` desnecessário para STRING | Otimização de tipos | Média |
| 28 | `RAND()` - função não determinística em query persistente | Evitar não-determinismo | Alta |
| 31 | Bronze → Trusted direto sem DLT | DLT obrigatório para Trusted/Refined | Crítica |

**Total: 6 violações**

---

## Python

### `estoque_produtos.py`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 1-7 | Cabeçalho obrigatório ausente | Cabeçalho obrigatório | Crítica |
| 6 | `/dbfs/mnt/producao/catalogo_estoque` - path hardcoded | Não usar paths hardcoded | Crítica |
| 6 | `inferSchema=True` - inferência sem validação | Schema explícito obrigatório | Alta |
| 10 | `/mnt/refined/estoque_produtos` - path hardcoded | Não usar paths hardcoded | Crítica |
| 12 | Bronze → Refined direto (pula Trusted) | Respeitar bronze→trusted→refined | Crítica |
| 12-13 | Transformação de Refined sem DLT | DLT obrigatório para Refined | Crítica |
| 15 | `refined.estoque_consolidado` - catálogo implícito | Não usar catálogos hardcoded | Crítica |
| 1-15 | Sem StructType/schema explícito | Schema explícito com comentários | Alta |
| 1-15 | Uso de print em vez de logger | Preferir logger do projeto | Baixa |

**Total: 9 violações**

---

### `dados_clientes.py`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 14 | `API_KEY = "sk_live_..."` - segredo hardcoded | Nunca hardcode segredos | **CRÍTICA** |
| 15 | `DB_PASSWORD = "Produc@o2025!"` - senha hardcoded | Nunca hardcode segredos | **CRÍTICA** |
| 17-22 | Senha em texto claro na conexão JDBC | Usar dbutils.secrets | **CRÍTICA** |
| 24 | `tmp_clientes_import_2026` - nome temporário sem metadados | Tabelas precisam de tags/descrição | Alta |
| 29-34 | `/Workspace/Repos/...` - path absoluto hardcoded | Não usar paths hardcoded | Crítica |
| 29-34 | `cluster-fixo-123` - cluster ID hardcoded | Parametrizar recursos | Alta |
| 1-34 | Sem validação Pandera (arquivo em schemas/) | Confirmar uso de Pandera | Alta |
| 1-34 | Sem StructType/schema explícito para Spark | Schema explícito obrigatório | Alta |

**Total: 8 violações**

---

## YAML

### `dlt_estoque.pipeline.yml`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 1 | `pipeline_controle_estoque` - não segue padrão `dlt_<processo>` | Nomenclatura de pipelines | Alta |
| 8 | `/Workspace/Repos/...` - path absoluto | Evitar paths absolutos | Crítica |
| 9 | `producao_estoque` - catálogo hardcoded | Parametrizar catálogos | Crítica |
| 13 | `target: /mnt/refined/...` - path absoluto hardcoded | Usar variáveis | Crítica |
| 15 | `caminho_bronze: "/dbfs/mnt/..."` - path hardcoded | Parametrizar paths | Crítica |
| 16 | `catalogo_destino: "refined_estoque"` - catálogo hardcoded | Usar variáveis de catálogo | Crítica |
| Nome arquivo | Deveria ser `dlt_estoque.pipeline.yml` | Nomenclatura padrão | Alta |

**Total: 7 violações**

---

### `job_vendas.job.yml`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 1-17 | Ausência de `schedule` | Job deve ter schedule | **CRÍTICA** |
| 1-17 | Ausência de `webhook` | Job deve ter webhook (notificações) | Alta |
| 1-17 | Ausência de `permissions` | Job deve ter permissions (ACLs) | Alta |
| 11 | `/Workspace/Repos/...` - path absoluto | Evitar paths absolutos | Crítica |
| 9 | `existing_cluster_id: "cluster-prod-001"` - cluster hardcoded | Parametrizar recursos | Alta |
| Nome arquivo | Deveria ser `job_vendas.job.yml` ✓ (correto) | - | - |

**Total: 5 violações**

---

## Resumo Geral

| Arquivo | Total Violações | Críticas | Altas | Médias |
|---------|-----------------|----------|-------|--------|
| `controle_estoque.sql` | 6 | 4 | 1 | 1 |
| `relatorio_vendas.sql` | 5 | 2 | 1 | 2 |
| `clientes_ativos.sql` | 6 | 1 | 3 | 2 |
| `estoque_produtos.py` | 9 | 6 | 2 | 1 |
| `dados_clientes.py` | 8 | 6 | 2 | 0 |
| `dlt_estoque.pipeline.yml` | 7 | 5 | 2 | 0 |
| `job_vendas.job.yml` | 5 | 3 | 2 | 0 |
| **TOTAL** | **46** | **27** | **13** | **6** |

---

## Cobertura de Regras

### ✅ Regras Cobertas (100%)

**Segurança & Governança:**
- [x] Hardcode de segredos/senhas (dados_clientes.py)
- [x] Hardcode de API keys (dados_clientes.py)
- [x] Catálogos hardcoded (múltiplos arquivos)
- [x] Paths absolutos hardcoded (múltiplos arquivos)

**Integridade & Confiabilidade:**
- [x] Bronze → Refined direto (controle_estoque.sql, relatorio_vendas.sql, estoque_produtos.py)
- [x] DLT não usado em Trusted/Refined (múltiplos arquivos)
- [x] DELETE sem WHERE (controle_estoque.sql)
- [x] UPDATE sem WHERE específico (controle_estoque.sql)
- [x] Tipos inconsistentes (múltiplos SQL)
- [x] Joins incorretos com LIKE (relatorio_vendas.sql)
- [x] Funções não determinísticas (clientes_ativos.sql)

**Manutenibilidade:**
- [x] Cabeçalho ausente (estoque_produtos.py)
- [x] SELECT * (controle_estoque.sql)
- [x] Tabelas sem comentários (múltiplos SQL)
- [x] Nomes de tabela ruins/temporários (múltiplos arquivos)
- [x] Inferência de schema (estoque_produtos.py)
- [x] Schema StructType ausente (estoque_produtos.py)
- [x] Queries aninhadas excessivas (relatorio_vendas.sql)
- [x] CAST desnecessário (clientes_ativos.sql)

**YAML Específico:**
- [x] Nomenclatura incorreta (dlt_estoque.pipeline.yml)
- [x] Job sem schedule (job_vendas.job.yml)
- [x] Job sem webhook (job_vendas.job.yml)
- [x] Job sem permissions (job_vendas.job.yml)
- [x] Cluster ID hardcoded (job_vendas.job.yml)

---

## Como Usar Este Checklist

1. **Antes da Revisão:** Confirmar que todos os arquivos estão no repositório
2. **Durante a Revisão:** Marcar quais problemas o Copilot identificou
3. **Após a Revisão:** Calcular % de detecção: (problemas encontrados / 46) × 100
4. **Meta de Qualidade:** Copilot deve identificar ≥ 90% das violações críticas (≥24/27)

---

## Observações

- Todos os arquivos simulam código de produção real
- Nenhum arquivo contém pistas explícitas de problemas
- Violações distribuídas naturalmente entre diferentes contextos de negócio
- Alguns arquivos combinam múltiplas violações (cenário realista)
