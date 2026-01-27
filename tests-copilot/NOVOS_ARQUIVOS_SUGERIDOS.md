# Arquivos Sugeridos para Cobertura Completa - Testes Copilot

**Data:** 2026-01-22  
**Objetivo:** Sugestões de novos arquivos de teste para cobrir regras ainda não testadas (gap de 16% na cobertura)

---

## 📊 Status de Cobertura Atual

- **Regras Totais:** 38
- **Regras Testadas:** 32
- **Cobertura Atual:** 84%
- **Meta:** ≥ 95%
- **Gap:** 6 regras sem teste

---

## 🆕 Arquivos SQL a Criar

### 1. `tests-copilot/sql/vendas_duplicadas.sql`

**Objetivo:** Testar detecção de JOINs que geram duplicatas sem tratamento

```sql
-- Autor: Pedro Alves
-- Data: 2026-01-15
-- Projeto: veritas
-- Camada: Trusted
-- Tabela: tb_vendas_duplicadas
-- Objetivo: Consolidar vendas por cliente
-- Versão: 1.0.0
-- Histórico de Atualizações:
-- 2026-01-15 - Pedro Alves - Versão inicial

CREATE TABLE trusted.tb_vendas_duplicadas AS
SELECT 
    v.id_venda,
    v.valor,
    c.nome_cliente,
    p.nome_produto
FROM bronze.vendas v
LEFT JOIN bronze.clientes c ON v.cliente_id = c.id
LEFT JOIN bronze.produtos p ON v.produto_id = p.categoria
-- PROBLEMA: JOIN por categoria (1:N) gera duplicatas não tratadas
-- FALTA: DISTINCT ou GROUP BY para deduplicar
WHERE v.data_venda >= '2025-01-01';
```

**Violações Esperadas:**
- JOIN que gera duplicatas sem tratamento (CRITICAL)
- JOIN em campo não-único (categoria em vez de id) (Alta)

---

### 2. `tests-copilot/sql/clientes_pii_exposta.sql`

**Objetivo:** Testar detecção de PII sem mascaramento

```sql
-- Autor: Julia Mendes
-- Data: 2026-01-18
-- Projeto: veritas
-- Camada: Refined
-- Tabela: vw_clientes_relatorio
-- Objetivo: View de clientes para relatórios externos
-- Versão: 1.1.0
-- Histórico de Atualizações:
-- 2026-01-18 - Julia Mendes - Criação

CREATE OR REPLACE VIEW refined.vw_clientes_relatorio AS
SELECT 
    id_cliente,
    nome_completo,
    cpf,  -- PROBLEMA: CPF exposto sem mascaramento
    email,  -- PROBLEMA: Email exposto sem mascaramento
    telefone,  -- PROBLEMA: Telefone exposto
    endereco_completo,
    renda_mensal  -- PROBLEMA: Dado sensível sem proteção
FROM trusted.dim_clientes
WHERE status = 'ATIVO';

-- FALTA: Mascaramento de PII (ex: CONCAT(LEFT(cpf,3), '***.***-**'))
-- FALTA: Controle de acesso/permissões mencionado
```

**Violações Esperadas:**
- PII exposta sem mascaramento (CRITICAL - 4 campos)
- Dados sensíveis sem proteção (CRITICAL)

---

### 3. `tests-copilot/incorreto/relatorio_fora_de_local.sql`

**Objetivo:** Testar arquivo SQL em diretório incorreto (fora de `app_file/sql/`)

```sql
-- Autor: Roberto Lima
-- Data: 2026-01-20
-- Projeto: veritas
-- Camada: Bronze
-- Tabela: tb_log_imports
-- Objetivo: Registrar logs de importação
-- Versão: 1.0.0
-- Histórico de Atualizações:
-- 2026-01-20 - Roberto Lima - Criação

-- PROBLEMA: Arquivo está em tests-copilot/incorreto/ 
-- em vez de app_file/sql/

SELECT TRUE
FROM dev_stg_adls.app_files.tb_controle
WHERE file_name = 'relatorio_fora_de_local';

CREATE TABLE bronze.tb_log_imports (
    id_log INT COMMENT 'ID do log',
    data_import TIMESTAMP COMMENT 'Data da importação',
    status STRING COMMENT 'Status do processamento'
) COMMENT 'Tabela de logs de importação';
```

**Violações Esperadas:**
- Arquivo SQL fora de `app_file/sql/` (CRITICAL)

---

## 🆕 Arquivos Python a Criar

### 4. `tests-copilot/schemas/processamento_com_prints.py`

**Objetivo:** Testar uso de `print()` em vez de logger

```python
# Autor: Fernanda Costa
# Data: 2026-01-19
# Projeto: veritas
# Camada: Bronze
# Tabela: tb_processamento_logs
# Objetivo: Processar logs de sistema
# Versão: 1.0.0
# Histórico de Atualizações:
# 2026-01-19 - Fernanda Costa - Criação inicial

from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, TimestampType

spark = SparkSession.builder.getOrCreate()

# PROBLEMA: Usando print() em vez de logger
print("Iniciando processamento de logs...")

schema = StructType([
    StructField("timestamp", TimestampType(), False, metadata={"comment": "Data/hora do evento"}),
    StructField("nivel", StringType(), False, metadata={"comment": "Nível de log"}),
    StructField("mensagem", StringType(), False, metadata={"comment": "Mensagem do log"})
])

df = spark.read.schema(schema).json("dbfs:/mnt/bronze/logs/sistema.json")

print(f"Total de registros lidos: {df.count()}")  # PROBLEMA: print em vez de logger

df_filtrado = df.filter("nivel IN ('ERROR', 'CRITICAL')")

print("Salvando dados filtrados...")  # PROBLEMA: print

df_filtrado.write.mode("append").saveAsTable("bronze.tb_processamento_logs")

print("Processamento concluído com sucesso!")  # PROBLEMA: print
```

**Violações Esperadas:**
- Uso de `print()` em vez de logger (Alta - 4 ocorrências)

---

### 5. `tests-copilot/schemas/tabela_grande_sem_otimizacao.py`

**Objetivo:** Testar ausência de Z-ORDER em tabela grande com padrão de acesso conhecido

```python
# Autor: Ricardo Souza
# Data: 2026-01-17
# Projeto: veritas
# Camada: Refined
# Tabela: tb_transacoes_consolidadas
# Objetivo: Consolidar transações para análises (tabela com 500M+ registros)
# Versão: 2.0.0
# Histórico de Atualizações:
# 2026-01-17 - Ricardo Souza - Criação

from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, DecimalType, DateType, IntegerType

spark = SparkSession.builder.getOrCreate()

schema = StructType([
    StructField("id_transacao", IntegerType(), False, metadata={"comment": "ID da transação"}),
    StructField("data_transacao", DateType(), False, metadata={"comment": "Data da transação"}),
    StructField("id_cliente", IntegerType(), False, metadata={"comment": "ID do cliente"}),
    StructField("id_produto", IntegerType(), False, metadata={"comment": "ID do produto"}),
    StructField("valor", DecimalType(15,2), False, metadata={"comment": "Valor da transação"}),
    StructField("regiao", StringType(), False, metadata={"comment": "Região da venda"})
])

# Processa tabela grande (500M+ registros)
df = spark.table("trusted.transacoes_processadas")

df_consolidado = df.groupBy("data_transacao", "id_cliente", "regiao") \
    .agg({"valor": "sum", "id_transacao": "count"})

# PROBLEMA: Salvando tabela grande sem otimização
# FALTA: .option("optimizeWrite", "true")
# FALTA: Z-ORDER por data_transacao, id_cliente (campos mais consultados)
df_consolidado.write.mode("overwrite") \
    .format("delta") \
    .saveAsTable("refined.tb_transacoes_consolidadas")

# FALTA: Comando OPTIMIZE com Z-ORDER
# Deveria ter após write:
# spark.sql("OPTIMIZE refined.tb_transacoes_consolidadas ZORDER BY (data_transacao, id_cliente)")
```

**Violações Esperadas:**
- Tabela grande sem `optimizeWrite` (Alta)
- Ausência de Z-ORDER em tabela com padrão de acesso conhecido (Alta)

---

## 🆕 Arquivos YAML a Criar

### 6. `tests-copilot/resources/pipeline_invalido.yml`

**Objetivo:** Testar YAML com sintaxe inválida (indentação quebrada)

```yaml
name: pipeline_teste_invalido

resources:
  pipelines:
    teste_invalido:
      name: teste_invalido
      libraries:
        - notebook:
          path: /notebooks/processa_teste  # PROBLEMA: Indentação errada
      catalog: ${var.catalog}
      schema: ${var.schema}
    photon: true  # PROBLEMA: Indentação errada (deveria estar dentro de teste_invalido)
      serverless: false
      target: ${var.target_path}
```

**Violações Esperadas:**
- YAML inválido - indentação incorreta (CRITICAL - 2 locais)
- YAML não parseável (CRITICAL)

---

### 7. `tests-copilot/resources/job_com_segredo.yml`

**Objetivo:** Testar segredo hardcoded em YAML

```yaml
name: job_api_externa

resources:
  jobs:
    api_externa_sync:
      name: api_externa_sync
      schedule:
        quartz_cron_expression: "0 0 * * * ?"
        timezone_id: America/Sao_Paulo
      tasks:
        - task_key: sync_api
          spark_python_task:
            python_file: /notebooks/sync_api.py
            parameters:
              - "--api-key"
              - "sk_prod_ABCdef123456789"  # PROBLEMA: API key hardcoded
              - "--endpoint"
              - "https://api.externa.com/v1/dados"
          new_cluster:
            spark_version: "13.3.x-scala2.12"
            node_type_id: "Standard_DS3_v2"
            num_workers: 2
            spark_env_vars:
              DB_PASSWORD: "SenhaProducao@2025!"  # PROBLEMA: Senha hardcoded
              API_SECRET: "secret_key_prod_xyz"  # PROBLEMA: Segredo hardcoded
      webhook_notifications:
        on_failure:
          - id: "webhook-notif"
      permissions:
        - group_name: "grp_data_eng"
          level: "CAN_MANAGE_RUN"
```

**Violações Esperadas:**
- API key hardcoded em parâmetros (CRITICAL)
- Senha hardcoded em variável de ambiente (CRITICAL)
- Segredo hardcoded em variável de ambiente (CRITICAL)

---

### 8. `tests-copilot/resources/job_sintaxe_github_actions.yml`

**Objetivo:** Testar mistura de sintaxe GitHub Actions em job Databricks

```yaml
name: job_pipeline_vendas

# PROBLEMA: Sintaxe do GitHub Actions misturada
on:  # PROBLEMA: Campo 'on' é do GitHub Actions, não de jobs Databricks
  schedule:
    - cron: "0 6 * * *"  # PROBLEMA: Formato GitHub Actions

resources:
  jobs:
    vendas_pipeline:
      name: vendas_pipeline
      # FALTA: schedule no formato correto (quartz_cron_expression)
      steps:  # PROBLEMA: 'steps' é do GitHub Actions, deveria ser 'tasks'
        - name: processar_vendas  # PROBLEMA: 'name' em vez de 'task_key'
          run: /notebooks/vendas/processamento  # PROBLEMA: 'run' em vez de 'notebook_task'
      permissions:
        - group_name: "grp_vendas"
          level: "CAN_VIEW"
```

**Violações Esperadas:**
- Uso de `on:` (sintaxe GitHub Actions) (CRITICAL)
- Uso de `steps:` em vez de `tasks:` (CRITICAL)
- Uso de `name:` em task em vez de `task_key:` (Alta)
- Uso de `run:` em vez de `notebook_task:` (Alta)
- Formato de cron do GitHub Actions em vez de quartz (Alta)

---

## 📋 Resumo de Novos Arquivos

| Arquivo | Tipo | Violações | Regras Cobertas |
|---------|------|-----------|-----------------|
| `vendas_duplicadas.sql` | SQL | 2 | JOINs com duplicatas |
| `clientes_pii_exposta.sql` | SQL | 5 | PII sem mascaramento |
| `incorreto/relatorio_fora_de_local.sql` | SQL | 1 | Arquivo em local errado |
| `processamento_com_prints.py` | Python | 4 | print() vs logger |
| `tabela_grande_sem_otimizacao.py` | Python | 2 | Z-ORDER ausente |
| `pipeline_invalido.yml` | YAML | 3 | YAML inválido |
| `job_com_segredo.yml` | YAML | 3 | Segredos hardcoded |
| `job_sintaxe_github_actions.yml` | YAML | 5 | Sintaxe misturada |
| **TOTAL** | - | **25** | **6 regras novas** |

---

## 📈 Impacto na Cobertura

**Após criar estes arquivos:**
- **Regras Totais:** 38
- **Regras Testadas:** 38 (100%)
- **Total de Violações:** 76 + 25 = **101 violações**
- **Cobertura:** **100%** ✅

---

## 🔧 Instruções de Criação

1. **Criar diretório adicional:**
   ```
   tests-copilot/incorreto/
   ```

2. **Criar os 8 arquivos listados acima** com o conteúdo exato

3. **Atualizar `CHECKLIST_VIOLACOES.md`** com as novas seções

4. **Executar teste completo do Copilot Code Review**

5. **Meta final:** ≥ 90% de detecção (≥91/101 violações)

---

## ⚠️ Observações Importantes

- Todos os novos arquivos seguem o padrão de "erros sutis" (não óbvios)
- Cada arquivo foca em 1-2 tipos de violação para facilitar validação
- `job_com_segredo.yml` testa múltiplos segredos para cobrir diferentes contextos
- `pipeline_invalido.yml` deve ter erro de parsing real (YAML quebrado)
- `job_sintaxe_github_actions.yml` testa conhecimento específico de sintaxe Databricks

---

**Fim das Sugestões**
