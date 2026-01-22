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

### `faturamento_de_vendas.sql`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 1-10 | Cabeçalho **fora de ordem** - campos misturados | Cabeçalho obrigatório estruturado | Alta |
| 1 | `Autor: Fulano` - nome genérico/não profissional | Identificação adequada | Média |
| 2 | Campo `Objetivo` aparece antes de `Data` - ordem incorreta | Ordem padrão de cabeçalho | Alta |
| 10 | `Camada: raw` - deveria ser `Bronze` (nomenclatura oficial) | Nomenclatura padronizada de camadas | Média |
| 10-17 | Campos `Projeto` e `Camada` aparecem no **final** do cabeçalho | Ordem padrão de cabeçalho | Alta |
| 11-17 | Tabela criada **sem comentários** de colunas | Comentar colunas e tabelas | Alta |
| 13 | `qtd_data` - nome de coluna confuso (qtd sugere quantidade, mas é data) | Nomes claros e padronizados | Alta |

**Total: 7 violações**

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

### `faturamento_de_vendas.py`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 1-28 | Cabeçalho **fora de ordem** - campos misturados ao longo do arquivo | Cabeçalho obrigatório estruturado | Alta |
| 2 | `#tabela: tb_stg_faturamento_de_vendas` **inline** com comentário (linha 2) | Formato correto de cabeçalho | Alta |
| 3 | Campo `# Data:` aparece **depois** de `Autor` e `tabela` | Ordem padrão de cabeçalho | Alta |
| 27-28 | Campos `# Projeto` e `# Camada` aparecem no **final** do arquivo | Ordem padrão de cabeçalho | Alta |
| 12 | `"id_cliente": pa.Column(pa.String, nullable=True)` - PK não pode ser nullable | Validação Pandera - constraints adequados | **CRÍTICA** |
| 14 | `"qtd_data"` - nome confuso (qtd sugere quantidade) | Nomes claros e padronizados | Alta |
| 23 | `"sub_sistema": None` em metadata - informação incompleta | Metadados completos e coerentes | Média |

**Total: 7 violações**

---

## Notebooks

### `tb_mov_vendas.ipynb` (DLT)

| Célula/Linha | Violação | Regra | Prioridade |
|--------------|----------|-------|------------|
| Célula 1 | **Sem cabeçalho** obrigatório no notebook | Cabeçalho obrigatório | **CRÍTICA** |
| Célula 2, linha 5 | Função `@dlt.table` não especifica de qual **camada bronze** lê | Bronze → Trusted → Refined | Alta |
| Célula 2, linha 6 | Lê de `tb_stg_faturamento_de_vendas` - **staging sem prefixo de camada** | Nomenclatura clara de camadas | Média |
| Célula 2, linha 8 | Mantém nome `"id_cliente"` - **abreviação** (deveria ser `id_cliente_completo` ou similar) | Nomes claros e padronizados | Alta |
| Célula 2, linha 8 | Mantém `"qtd_data"` - **nome confuso** (qtd = quantidade?) | Nomes claros e padronizados | Alta |
| Célula 2, linha 8 | Mantém `"num_valor_total"` - **prefixo de tipo desnecessário** | Nomes claros e padronizados | Alta |

**Total: 6 violações**

---

### `tags_tb_mov_vendas.ipynb` (Tags)

| Célula/Linha | Violação | Regra | Prioridade |
|--------------|----------|-------|------------|
| Célula 1 | Tabela tem apenas **2 tags** (mínimo exigido é 2) ⚠️ **No limite mínimo aceitável** | Tags mínimas: 2 na tabela | **CRÍTICA** |
| Célula 1 | Coluna `id_cliente` tem apenas **3 tags** (mínimo exigido: **6**) | Tags mínimas: 6 em colunas | **CRÍTICA** |
| Célula 1 | Colunas `qtd_data` e `num_valor_total` **sem nenhuma tag** | Tags mínimas: 6 em colunas | **CRÍTICA** |
| Notebook | **Sem descrição textual** da tabela (somente tags listadas) | Descrições coerentes e completas | Alta |
| Notebook | **Sem metadados estruturados** (área, sistema, owner, etc.) | Metadados coerentes | Alta |

**Total: 5 violações**

---

## YAML

### `dlt_estoque.pipeline.yml`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 1 | `pipeline_controle_estoque` - não segue padrão `dlt_<processo>` | Nomenclatura de pipelines | Alta |
| 1 | Ausência de campo `description:` | Documentação obrigatória | Alta |
| 8 | `/Workspace/Repos/...` - path absoluto | Evitar paths absolutos | Crítica |
| 9 | `producao_estoque` - catálogo hardcoded | Parametrizar catálogos | Crítica |
| 13 | `target: /mnt/refined/...` - path absoluto hardcoded | Usar variáveis | Crítica |
| 15 | `caminho_bronze: "/dbfs/mnt/..."` - path hardcoded | Parametrizar paths | Crítica |
| 16 | `catalogo_destino: "refined_estoque"` - catálogo hardcoded | Usar variáveis de catálogo | Crítica |
| Nome arquivo | Deveria ser `dlt_estoque.pipeline.yml` | Nomenclatura padrão | Alta |

**Total: 8 violações**

---

### `dlt_financeiro.pipeline.yml`

| Linha | Violação | Regra | Prioridade |
|-------|----------|-------|------------|
| 1 | Arquivo **sem** campo `name:` no nível raiz | Estrutura mínima de pipeline YAML | Alta |
| 8 | `path: /tests-copilot/dlt/tb_mov_vendas.ipynb` - path relativo à raiz do repo (não ao workspace) | Paths corretos | Média |
| 9 | `schema: financeiro` - schema hardcoded | Parametrizar schemas | Alta |
| 10 | `catalog: prd_raw_adls` - catálogo hardcoded | Parametrizar catálogos | **CRÍTICA** |

**Total: 4 violações**

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

### `job_financeiro.job.yml` ✅ (EXEMPLO POSITIVO)

**Este arquivo segue TODAS as boas práticas!** Serve como **exemplo correto**:
- ✅ Tem `schedule` completo com timezone
- ✅ Tem `permissions` configurado adequadamente
- ✅ Usa referência dinâmica `${resources.pipelines...}`
- ✅ Tem `queue` e `performance_target` configurados
- ✅ Estrutura completa e válida

**Total: 0 violações (arquivo modelo)**

---

## Resumo Geral

| Arquivo | Total Violações | Críticas | Altas | Médias |
|---------|-----------------|----------|-------|--------|
| `controle_estoque.sql` | 6 | 4 | 1 | 1 |
| `relatorio_vendas.sql` | 5 | 2 | 1 | 2 |
| `clientes_ativos.sql` | 6 | 1 | 3 | 2 |
| `faturamento_de_vendas.sql` | 7 | 0 | 5 | 2 |
| `estoque_produtos.py` | 9 | 6 | 2 | 1 |
| `dados_clientes.py` | 8 | 6 | 2 | 0 |
| `faturamento_de_vendas.py` | 7 | 1 | 5 | 1 |
| `tb_mov_vendas.ipynb` | 6 | 1 | 4 | 1 |
| `tags_tb_mov_vendas.ipynb` | 5 | 3 | 2 | 0 |
| `dlt_estoque.pipeline.yml` | 8 | 5 | 3 | 0 |
| `dlt_financeiro.pipeline.yml` | 4 | 1 | 2 | 1 |
| `job_vendas.job.yml` | 5 | 3 | 2 | 0 |
| `job_financeiro.job.yml` ✅ | 0 | 0 | 0 | 0 |
| **TOTAL** | **76** | **33** | **32** | **11** |

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
   - **Total:** (problemas encontrados / 76) × 100
   - **Críticos:** (críticos encontrados / 33) × 100
4. **Meta de Qualidade:** 
   - Copilot deve identificar **≥ 90%** das violações críticas (**≥30/33**)
   - Copilot deve identificar **≥ 80%** do total de violações (**≥61/76**)

---

## ✅ Arquivo de Exemplo CORRETO

### `job_financeiro.job.yml` - Referência de Boas Práticas

Este arquivo **não contém violações** e serve como **modelo** de implementação correta:
- ✅ Schedule configurado com timezone adequado
- ✅ Permissions definidas corretamente
- ✅ Usa referências dinâmicas (`${resources.pipelines...}`)
- ✅ Queue e performance_target configurados
- ✅ Estrutura YAML válida e completa

**Use este arquivo como referência para validar que o Copilot reconhece código correto.**

---

## Observações

- Todos os arquivos simulam código de produção real
- Nenhum arquivo contém pistas explícitas de problemas (exceto `job_financeiro.job.yml` que está correto)
- Violações distribuídas naturalmente entre diferentes contextos de negócio
- Alguns arquivos combinam múltiplas violações (cenário realista)
- **Novo:** Inclui violações de **cabeçalho fora de ordem** (testa atenção a detalhes)
- **Novo:** Inclui notebooks DLT e de tags (testa regras específicas de notebooks
## Observações

- Todos os arquivos simulam código de produção real
- Nenhum arquivo contém pistas explícitas de problemas
- Violações distribuídas naturalmente entre diferentes contextos de negócio
- Alguns arquivos combinam múltiplas violações (cenário realista)
