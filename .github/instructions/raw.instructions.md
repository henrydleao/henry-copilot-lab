---
applyTo: "**/*.{py,sql}"
---

# Regras para Camada Bronze/RAW – Data Lakehouse

Estas instruções se aplicam a **arquivos que criam, modificam ou ingerem dados na camada Bronze/RAW**. O Copilot deve validar governança e qualidade desde a ingestão inicial.

> **Importante**: Aplicar estas regras quando detectar no código ou metadados: `Camada: Bronze`, tabelas em schema `bronze.*`, ou processos de ingestão inicial.

---

## 1) Campos de Auditoria Obrigatórios

**Toda tabela Bronze deve incluir campos de controle:**

```sql
-- SQL
CREATE TABLE bronze.{tabela} (
  -- colunas de negócio...
  
  -- CAMPOS OBRIGATÓRIOS DE AUDITORIA:
  dt_carga TIMESTAMP COMMENT 'Data/hora da ingestão',
  dt_processamento TIMESTAMP COMMENT 'Data/hora do processamento',
  id_execucao STRING COMMENT 'Identificador único da execução/lote',
  origem_sistema STRING COMMENT 'Sistema/fonte de origem dos dados'
)
```

```python
# Python/PySpark - Adicionar ao DataFrame
from pyspark.sql import functions as F

df = df.withColumn("dt_carga", F.current_timestamp()) \
       .withColumn("dt_processamento", F.current_timestamp()) \
       .withColumn("id_execucao", F.lit(execution_id)) \
       .withColumn("origem_sistema", F.lit("SAP"))
```

**O Copilot deve:**
- ✅ **Alertar** quando criar tabela Bronze sem estes 4 campos
- ✅ **Sugerir** inclusão automática quando detectar ingestão de dados

---

## 2) Formato de Persistência

**Obrigatório**: usar **Delta Lake** ou **Parquet** (nunca CSV/JSON em produção).

```python
# ✅ CORRETO
df.write.format("delta").save(path)
df.write.format("parquet").save(path)

# ❌ EVITAR (alertar em code review)
df.write.format("csv").save(path)
df.write.format("json").save(path)
```

**O Copilot deve:**
- ❌ **Alertar** quando detectar `.format("csv")` ou `.format("json")` em tabelas Bronze
- ✅ **Sugerir** migração para Delta/Parquet

---

## 3) Compressão

**Recomendado**: usar compressão **Snappy** (padrão) ou **ZSTD** (maior compressão).

```python
# ✅ BOAS PRÁTICAS
df.write.format("parquet") \
    .option("compression", "snappy") \
    .save(path)

# Ou para maior compressão
.option("compression", "zstd")
```

**O Copilot deve:**
- ✅ **Sugerir** definir compressão explicitamente quando ausente

---

## 4) Particionamento por Data de Carga

**Obrigatório**: particionar tabelas Bronze por `dt_carga` (facilita reprocessamento e purga).

```sql
-- SQL
CREATE TABLE bronze.{tabela} (...)
PARTITIONED BY (dt_carga)
```

```python
# Python/PySpark
df.write.format("delta") \
    .partitionBy("dt_carga") \
    .save(path)
```

**O Copilot deve:**
- ✅ **Alertar** quando criar tabela Bronze sem particionamento
- ✅ **Sugerir** `PARTITIONED BY (dt_carga)` ou `.partitionBy("dt_carga")`

---

## 5) Validações de Qualidade na Ingestão

**Obrigatório**: incluir validações básicas em processos de ingestão.

```python
# VALIDAÇÕES MÍNIMAS EM BRONZE
# 1. Contagem de registros
count_origem = df_origem.count()
count_destino = spark.table("bronze.tabela").count()
assert count_destino >= count_origem, f"Perda de registros: {count_origem} → {count_destino}"

# 2. Detecção de duplicatas (quando aplicável)
df_deduplicado = df.dropDuplicates(["id_primaria"])
duplicatas = df.count() - df_deduplicado.count()
if duplicatas > 0:
    logger.warning(f"Removidas {duplicatas} duplicatas")

# 3. Verificação de schema (evitar schema drift)
assert df.schema == expected_schema, "Schema divergente da especificação"
```

**O Copilot deve:**
- ✅ **Sugerir** validação de contagem em processos de ingestão
- ✅ **Alertar** quando houver risco de duplicatas sem tratamento
- ✅ **Recomendar** validação de schema quando detectar `.option("inferSchema", "true")`

---

## 6) Nomenclatura de Tabelas Bronze

**Padrão obrigatório**: `{origem}_{entidade}` ou `{origem}_{tipo}_{entidade}`

```sql
-- ✅ CORRETO
CREATE TABLE bronze.sap_vendas_pedidos
CREATE TABLE bronze.api_crm_clientes
CREATE TABLE bronze.file_csv_estoque

-- ❌ EVITAR (nomes genéricos/opacos)
CREATE TABLE bronze.tb_dados
CREATE TABLE bronze.temp_import
CREATE TABLE bronze.tabela1
```

**O Copilot deve:**
- ❌ **Alertar** quando nome não identificar origem/sistema
- ✅ **Sugerir** renomeação seguindo padrão `{origem}_{entidade}`

---

## 7) Estratégia de Carga (identificação)

O Copilot deve **identificar e validar** a estratégia de carga no código:

```python
# FULL LOAD (sobrescrever tudo)
df.write.mode("overwrite").save(path)  # ✅ OK para full load

# INCREMENTAL (apenas novos)
df.write.mode("append").save(path)  # ✅ OK para incremental

# UPSERT (merge)
deltaTable.merge(df, "source.id = target.id") \
    .whenMatchedUpdateAll() \
    .whenNotMatchedInsertAll() \
    .execute()  # ✅ OK para CDC/upsert
```

**O Copilot deve:**
- ✅ Validar coerência: `mode("append")` sem validação de duplicatas → **alertar**
- ✅ Sugerir documentação da estratégia no cabeçalho (campo "Objetivo")

---

## 8) Revisão Rápida (Checklist para PR)

- [ ] **4 campos obrigatórios** presentes: `dt_carga`, `dt_processamento`, `id_execucao`, `origem_sistema`?
- [ ] **Formato**: Delta ou Parquet (não CSV/JSON)?
- [ ] **Compressão**: Snappy ou ZSTD definida?
- [ ] **Particionamento**: `PARTITIONED BY (dt_carga)` ou `.partitionBy("dt_carga")`?
- [ ] **Validações**: contagem de registros, duplicatas, schema verificados?
- [ ] **Nomenclatura**: `{origem}_{entidade}` seguida?
- [ ] **Estratégia de carga**: documentada e coerente com `.mode()`?

---

## 9) Anti‑padrões que o Copilot NÃO deve sugerir

- ❌ Tabelas Bronze sem campos de auditoria (`dt_carga`, `dt_processamento`, etc.)
- ❌ Persistência em CSV/JSON para dados de produção
- ❌ Tabelas Bronze sem particionamento por data
- ❌ Ingestão sem validação de contagem (origem vs. destino)
- ❌ Nomes genéricos (`tb_dados`, `temp_*`) sem identificação de origem
- ❌ `mode("append")` sem controle de duplicatas quando aplicável

---

## 10) Integração com Outras Instruções

Este arquivo **complementa** (não substitui) as regras de:
- `python.instructions.md` → cabeçalho, segredos, DLT
- `sql-instructions.instructions.md` → qualidade de SQL, comentários
- `copilot-instructions.md` → fluxo bronze → trusted → refined

**Em caso de dúvida**: regras de camada (este arquivo) têm **precedência** em aspectos de governança de dados.
