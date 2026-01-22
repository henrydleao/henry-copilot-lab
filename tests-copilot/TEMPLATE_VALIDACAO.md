# 📝 Template de Validação - Teste do GitHub Copilot

**Data do Teste:** _____/_____/_____  
**Testador:** _________________________________  
**PR Number:** #_______  
**Versão do Copilot:** _________________________

---

## 📋 Instruções de Uso

1. Criar PR com todos os arquivos de teste
2. Solicitar Code Review do GitHub Copilot
3. Para cada violação listada abaixo, marcar:
   - ✅ = Copilot detectou corretamente
   - ⚠️ = Copilot detectou parcialmente
   - ❌ = Copilot não detectou
4. Calcular as métricas no final

---

## 🗂️ SQL - controle_estoque.sql (6 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 1 | 11 | `qtd_estoque STRING` deveria ser INT/DECIMAL | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 2 | 12 | `dt_ultima_atualizacao STRING` deveria ser TIMESTAMP | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 3 | 17-19 | `SELECT *` em query persistente | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 4 | 17 | Bronze → Refined direto (pula Trusted) | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 5 | 21-22 | `UPDATE` sem `WHERE` específico | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 6 | 24 | `DELETE` sem `WHERE` | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/6 detectadas

---

## 🗂️ SQL - relatorio_vendas.sql (5 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 7 | 10 | `producao_vendas` - catálogo hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 8 | 16 | Bronze → Refined direto | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 9 | 17 | `JOIN ... ON ... LIKE` - operador incorreto | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 10 | 22 | `temp_vendas_2025` - prefixo temporário | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 11 | 23-31 | Queries aninhadas excessivas (3 níveis) | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/5 detectadas

---

## 🗂️ SQL - clientes_ativos.sql (6 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 12 | 13 | `tblCliAtv` - nome opaco/abreviado | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 13 | 13-18 | Tabela sem comentários/descrições | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 14 | 14-15 | Tipos errados (STRING para data/status) | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 15 | 22-23 | `CAST` desnecessário para STRING | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 16 | 28 | `RAND()` - não determinístico | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 17 | 31 | Bronze → Trusted sem DLT | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/6 detectadas

---

## 🗂️ SQL - faturamento_de_vendas.sql (7 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 18 | 1-10 | Cabeçalho fora de ordem | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 19 | 1 | `Autor: Fulano` - nome genérico | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 20 | 2 | `Objetivo` antes de `Data` | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 21 | 10 | `Camada: raw` (deveria ser Bronze) | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 22 | 10-17 | `Projeto` e `Camada` no final | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 23 | 11-17 | Tabela sem comentários de coluna | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 24 | 13 | `qtd_data` - nome confuso | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/7 detectadas

---

## 🐍 Python - estoque_produtos.py (9 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 25 | 1-7 | Cabeçalho obrigatório ausente | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 26 | 6 | Path hardcoded `/dbfs/mnt/producao/...` | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 27 | 6 | `inferSchema=True` sem validação | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 28 | 10 | Path hardcoded `/mnt/refined/...` | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 29 | 12 | Bronze → Refined direto | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 30 | 12-13 | Transformação Refined sem DLT | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 31 | 15 | `refined.estoque_consolidado` - catálogo implícito | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 32 | 1-15 | Sem StructType/schema explícito | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/8 detectadas (nota: item #25 conta como 1)

---

## 🐍 Python - dados_clientes.py (8 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 33 | 14 | `API_KEY = "sk_live_..."` - segredo hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |
| 34 | 15 | `DB_PASSWORD = "..."` - senha hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |
| 35 | 17-22 | Senha em JDBC | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |
| 36 | 24 | `tmp_clientes_import_2026` - nome temporário | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 37 | 29-34 | Path absoluto `/Workspace/Repos/...` | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 38 | 29-34 | `cluster-fixo-123` hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 39 | 1-34 | Sem validação Pandera | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 40 | 1-34 | Sem StructType explícito | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/8 detectadas

---

## 🐍 Python - faturamento_de_vendas.py (7 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 41 | 1-28 | Cabeçalho fora de ordem | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 42 | 2 | `#tabela:` inline | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 43 | 3 | `# Data:` depois de outros campos | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 44 | 27-28 | `Projeto` e `Camada` no final | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 45 | 12 | PK com `nullable=True` | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |
| 46 | 14 | `qtd_data` - nome confuso | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 47 | 23 | `sub_sistema: None` - metadata incompleta | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/7 detectadas

---

## 📓 Notebooks - tb_mov_vendas.ipynb (6 violações)

| # | Célula | Violação | Detectado? | Observações |
|---|--------|----------|------------|-------------|
| 48 | 1 | Sem cabeçalho obrigatório | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |
| 49 | 2, ln 5 | Não especifica camada bronze | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 50 | 2, ln 6 | `tb_stg_...` sem prefixo de camada | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 51 | 2, ln 8 | `id_cliente` - nome abreviado | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 52 | 2, ln 8 | `qtd_data` - nome confuso | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 53 | 2, ln 8 | `num_valor_total` - prefixo desnecessário | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/6 detectadas

---

## 📓 Notebooks - tags_tb_mov_vendas.ipynb (5 violações)

| # | Célula | Violação | Detectado? | Observações |
|---|--------|----------|------------|-------------|
| 54 | 1 | Tabela com apenas 2 tags (limite mínimo) | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |
| 55 | 1 | Coluna `id_cliente` com 3 tags (mín: 6) | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |
| 56 | 1 | Colunas `qtd_data` e `num_valor_total` sem tags | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |
| 57 | All | Sem descrição textual da tabela | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 58 | All | Sem metadados estruturados | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/5 detectadas

---

## 📦 YAML - dlt_estoque.pipeline.yml (8 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 59 | 1 | `pipeline_controle_estoque` - nomenclatura | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 60 | 1 | Sem campo `description:` | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 61 | 8 | `/Workspace/Repos/...` - path absoluto | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 62 | 9 | `producao_estoque` - catálogo hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 63 | 13 | `target: /mnt/refined/...` - path hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 64 | 15 | `caminho_bronze: "/dbfs/..."` - path hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 65 | 16 | `catalogo_destino: "refined_estoque"` - hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 66 | Nome | Nome de arquivo não segue padrão | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/8 detectadas

---

## 📦 YAML - dlt_financeiro.pipeline.yml (4 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 67 | 1 | Sem campo `name:` no nível raiz | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 68 | 8 | Path relativo incorreto | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 69 | 9 | `schema: financeiro` - hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 70 | 10 | `catalog: prd_raw_adls` - hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |

**Subtotal:** ___/4 detectadas

---

## 📦 YAML - job_vendas.job.yml (5 violações)

| # | Linha | Violação | Detectado? | Observações |
|---|-------|----------|------------|-------------|
| 71 | 1-17 | Ausência de `schedule` | ☐ ✅ ☐ ⚠️ ☐ ❌ | **CRÍTICO** |
| 72 | 1-17 | Ausência de `webhook` | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 73 | 1-17 | Ausência de `permissions` | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 74 | 11 | `/Workspace/Repos/...` - path absoluto | ☐ ✅ ☐ ⚠️ ☐ ❌ | |
| 75 | 9 | `existing_cluster_id: "cluster-prod-001"` - hardcoded | ☐ ✅ ☐ ⚠️ ☐ ❌ | |

**Subtotal:** ___/5 detectadas

---

## ✅ YAML - job_financeiro.job.yml (0 violações - CORRETO)

| # | Descrição | Validação | Observações |
|---|-----------|-----------|-------------|
| 76 | Arquivo exemplo correto | ☐ Copilot NÃO apontou problemas (esperado) | |
|  |  | ☐ Copilot apontou falsos positivos (ruim) | Detalhar: |

---

## 📊 Resultados Finais

### Contagem de Detecções

| Categoria | Detectadas | Total | % |
|-----------|------------|-------|---|
| **SQL** | ___/24 | 24 | ___% |
| **Python** | ___/23 | 23 | ___% |
| **Notebooks** | ___/11 | 11 | ___% |
| **YAML** | ___/17 | 17 | ___% |
| **Exemplo Correto** | ☐ Passou | 1 | - |
| **TOTAL GERAL** | **___/75** | **75** | **___%** |

### Detecções por Severidade

| Severidade | Detectadas | Total | % |
|------------|------------|-------|---|
| **Críticas** | ___/33 | 33 | ___% |
| **Altas** | ___/32 | 32 | ___% |
| **Médias** | ___/11 | 11 | ___% |

---

## 🎯 Avaliação de Qualidade

### Meta Mínima (80% total, 90% críticos)

- [ ] **PASSOU** - ≥60/75 total E ≥30/33 críticos
- [ ] **FALHOU** - Abaixo das metas

### Categorias com Performance Baixa (<70%)

1. ___________________________________ (___%)
2. ___________________________________ (___%)
3. ___________________________________ (___%)

### Principais Gaps Identificados

1. _______________________________________________________________
2. _______________________________________________________________
3. _______________________________________________________________

---

## 💡 Observações do Teste

### Falsos Positivos (Copilot alertou incorretamente)

1. Arquivo: _________________ | Linha: ____ | Descrição: _____________________
2. Arquivo: _________________ | Linha: ____ | Descrição: _____________________

### Detecções Parciais (Copilot mencionou mas não explicou bem)

1. Arquivo: _________________ | Linha: ____ | Descrição: _____________________
2. Arquivo: _________________ | Linha: ____ | Descrição: _____________________

### Qualidade das Sugestões do Copilot

- [ ] Excelente - Sugestões específicas e acionáveis
- [ ] Bom - Identificou problemas mas explicação genérica
- [ ] Regular - Identificou alguns problemas, faltou contexto
- [ ] Ruim - Não identificou problemas críticos

---

## 🚀 Próximos Passos

Com base nos resultados:

- [ ] Ajustar instruções em `.github/copilot-instructions.md`
- [ ] Ajustar instruções específicas em `.github/instructions/*.md`
- [ ] Criar novos casos de teste para gaps identificados
- [ ] Re-executar teste após ajustes
- [ ] Documentar lições aprendidas

---

## 📝 Notas Adicionais

_________________________________________________________________
_________________________________________________________________
_________________________________________________________________
_________________________________________________________________

---

**Teste concluído por:** ______________________ **Data:** _____/_____/_____
