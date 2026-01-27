---
applyTo: "**/*.{py,sql}"
---

# Regras para Camada Trusted – Data Lakehouse

Estas instruções se aplicam a **arquivos que criam, modificam ou transformam dados na camada Trusted**. O Copilot deve validar governança, qualidade e uso de DLT.

> **Importante**: Aplicar estas regras quando detectar no código ou metadados: `Camada: Trusted`, tabelas em schema `trusted.*`, ou pipelines DLT para esta camada.

---

## 1) DLT (Delta Live Tables) Obrigatório

**Toda transformação para Trusted DEVE usar Delta Live Tables.**

```python
# ✅ CORRETO - DLT
import dlt
from pyspark.sql import functions as F

@dlt.table(
    name="trusted.tb_clientes",
    comment="Clientes padronizados e limpos",
    table_properties={"quality": "gold", "pipelines.reset.allowed": "false"}
)
@dlt.expect_or_drop("cpf_valido", "length(cpf) = 11")
@dlt.expect_or_fail("id_obrigatorio", "id_cliente IS NOT NULL")
def clientes_trusted():
    return (
        dlt.read("bronze.clientes")
        .select(...)
        .transform(...)
    )
```

```sql
-- ✅ CORRETO - DLT em SQL
CREATE OR REFRESH STREAMING LIVE TABLE trusted.tb_vendas (
  CONSTRAINT id_valido EXPECT (id_venda IS NOT NULL) ON VIOLATION FAIL,
  CONSTRAINT valor_positivo EXPECT (valor > 0) ON VIOLATION DROP
)
COMMENT "Vendas padronizadas e validadas"
AS SELECT
  id_venda,
  CAST(valor AS DECIMAL(10,2)) AS valor,
  ...
FROM STREAM(live.bronze.vendas)
```

**O Copilot deve:**
- ❌ **Recusar** código Spark "puro" (sem DLT) para transformações de Trusted
- ✅ **Sugerir** migração para DLT quando detectar `spark.read()` → transformação → `write()` para Trusted
- ✅ **Exigir** decorators `@dlt.table` ou sintaxe `CREATE LIVE TABLE`

---

## 2) Validações de Qualidade com Expectations

**Obrigatório**: definir **expectativas de qualidade** (constraints) em todas as tabelas Trusted.

```python
# TIPOS DE EXPECTATIONS
@dlt.expect("nome_regra", "condicao")              # Log violations
@dlt.expect_or_drop("nome_regra", "condicao")     # Remove violações
@dlt.expect_or_fail("nome_regra", "condicao")     # Falha o pipeline

# EXEMPLOS PRÁTICOS
@dlt.expect_or_fail("pk_unica", "id IS NOT NULL")
@dlt.expect_or_drop("email_valido", "email RLIKE '^[^@]+@[^@]+\\.[^@]+$'")
@dlt.expect("data_coerente", "dt_venda >= '2020-01-01'")
@dlt.expect_or_drop("cpf_11_digitos", "length(cpf) = 11")
```

**O Copilot deve:**
- ✅ **Alertar** quando tabela Trusted não tiver expectations definidas
- ✅ **Sugerir** expectations mínimas:
  - Primary key NOT NULL (`expect_or_fail`)
  - Validações de tipo/formato (`expect_or_drop`)
  - Regras de negócio críticas (`expect_or_fail`)

---

## 3) Schema Explícito e Comentários

**Obrigatório**: definir schema explícito com **comentários em todas as colunas**.

```python
# ✅ CORRETO
from pyspark.sql.types import *

schema_clientes = StructType([
    StructField("id_cliente", LongType(), False, metadata={"comment": "Identificador único do cliente"}),
    StructField("cpf", StringType(), False, metadata={"comment": "CPF do cliente (11 dígitos)"}),
    StructField("nome", StringType(), False, metadata={"comment": "Nome completo do cliente"}),
    StructField("dt_cadastro", TimestampType(), False, metadata={"comment": "Data/hora do cadastro"}),
    StructField("ativo", BooleanType(), True, metadata={"comment": "Indica se cliente está ativo"})
])
```

```sql
-- ✅ CORRETO
CREATE OR REFRESH LIVE TABLE trusted.tb_produtos (
  id_produto BIGINT NOT NULL COMMENT 'Identificador único do produto',
  codigo_sku STRING NOT NULL COMMENT 'Código SKU do produto',
  descricao STRING COMMENT 'Descrição do produto',
  preco DECIMAL(10,2) NOT NULL COMMENT 'Preço unitário do produto',
  dt_atualizacao TIMESTAMP COMMENT 'Data/hora da última atualização'
)
```

**O Copilot deve:**
- ❌ **Alertar** quando usar `.option("inferSchema", "true")` em Trusted
- ❌ **Alertar** quando colunas não tiverem comentários
- ✅ **Sugerir** definição explícita de StructType/StructField

---

## 4) Padronização de Dados

**Obrigatório**: aplicar transformações de padronização.

```python
# PADRONIZAÇÕES COMUNS EM TRUSTED
from pyspark.sql import functions as F

df = df \
    .withColumn("cpf", F.regexp_replace("cpf", "[^0-9]", "")) \
    .withColumn("telefone", F.regexp_replace("telefone", "[^0-9]", "")) \
    .withColumn("nome", F.upper(F.trim("nome"))) \
    .withColumn("email", F.lower(F.trim("email"))) \
    .withColumn("cep", F.lpad(F.regexp_replace("cep", "[^0-9]", ""), 8, "0")) \
    .withColumn("dt_carga", F.to_timestamp("dt_carga", "yyyy-MM-dd HH:mm:ss"))
```

**O Copilot deve:**
- ✅ **Sugerir** padronização quando detectar campos de CPF, telefone, CEP sem tratamento
- ✅ **Sugerir** `upper(trim())` para campos textuais
- ✅ **Sugerir** conversão explícita de tipos (`to_timestamp`, `cast`)

---

## 5) Deduplicação Obrigatória

**Obrigatório**: remover duplicatas com estratégia documentada.

```python
# ESTRATÉGIAS DE DEDUPLICAÇÃO

# 1. Manter último registro (por timestamp)
from pyspark.sql.window import Window

window_spec = Window.partitionBy("id_cliente").orderBy(F.desc("dt_atualizacao"))
df_dedup = df.withColumn("row_num", F.row_number().over(window_spec)) \
             .filter("row_num = 1") \
             .drop("row_num")

# 2. Usar dropDuplicates (quando não há timestamp)
df_dedup = df.dropDuplicates(["id_cliente"])

# 3. Agregar duplicatas (quando apropriado)
df_agg = df.groupBy("id_cliente").agg(
    F.max("dt_atualizacao").alias("dt_atualizacao"),
    F.sum("valor").alias("valor_total")
)
```

**O Copilot deve:**
- ✅ **Alertar** quando não houver deduplicação explícita em Trusted
- ✅ **Sugerir** estratégia baseada em presença de timestamp
- ✅ **Validar** que chave de deduplicação está definida

---

## 6) Nomenclatura Padronizada

**Padrão obrigatório**: `tb_{entidade}` (sem prefixo de origem, pois já está padronizado).

```sql
-- ✅ CORRETO (Trusted)
CREATE LIVE TABLE trusted.tb_clientes
CREATE LIVE TABLE trusted.tb_vendas
CREATE LIVE TABLE trusted.tb_produtos

-- ❌ EVITAR (não repetir origem em Trusted)
CREATE LIVE TABLE trusted.sap_clientes  -- origem já foi em Bronze
CREATE LIVE TABLE trusted.raw_vendas    -- "raw" não pertence a Trusted
```

**O Copilot deve:**
- ✅ Validar padrão `tb_{entidade}` em Trusted
- ❌ **Alertar** quando nome incluir origem/sistema (isso é Bronze)
- ❌ **Alertar** quando usar prefixos temporários (`temp_`, `tmp_`)

---

## 7) Campos de Controle (herdados + novos)

**Obrigatório**: manter campos de Bronze + adicionar campos de Trusted.

```sql
CREATE OR REFRESH LIVE TABLE trusted.tb_vendas (
  -- colunas de negócio...
  id_venda BIGINT,
  valor DECIMAL(10,2),
  
  -- CAMPOS HERDADOS DE BRONZE:
  dt_carga TIMESTAMP,
  dt_processamento TIMESTAMP,
  id_execucao STRING,
  origem_sistema STRING,
  
  -- CAMPOS ADICIONAIS DE TRUSTED:
  dt_processamento_trusted TIMESTAMP COMMENT 'Data/hora processamento Trusted',
  hash_registro STRING COMMENT 'Hash MD5 para detecção de mudanças (SCD)',
  versao INT COMMENT 'Versão do registro (para SCD Type 2)'
)
```

**O Copilot deve:**
- ✅ **Alertar** se campos de auditoria de Bronze não forem propagados
- ✅ **Sugerir** `dt_processamento_trusted` para rastreabilidade
- ✅ **Sugerir** `hash_registro` quando detectar lógica SCD

---

## 8) Particionamento Otimizado

**Recomendado**: particionar por coluna de negócio (não apenas dt_carga).

```python
# ✅ BOAS PRÁTICAS - particionamento por negócio
@dlt.table(
    partition_cols=["ano_mes", "estado"]  # Particionamento funcional
)

# Ou em SQL
PARTITIONED BY (ano_mes, estado)
```

**O Copilot deve:**
- ✅ **Sugerir** particionamento por colunas de filtro comum (data, região, categoria)
- ⚠️ **Alertar** sobre over-partitioning (muitas partições pequenas)

---

## 9) SCD (Slowly Changing Dimensions) - Quando Aplicável

**Quando houver historização**: implementar SCD Type 1 ou Type 2.

```python
# SCD TYPE 2 - Manter histórico completo
@dlt.table(name="trusted.tb_clientes_historico")
def clientes_scd2():
    return dlt.read_stream("bronze.clientes") \
        .withColumn("hash_registro", F.md5(F.concat_ws("|", *cols_negocio))) \
        .withColumn("dt_inicio_vigencia", F.current_timestamp()) \
        .withColumn("dt_fim_vigencia", F.lit(None).cast("timestamp")) \
        .withColumn("registro_atual", F.lit(True))

# Merge logic para atualizar vigências...
```

**O Copilot deve:**
- ✅ **Sugerir** SCD Type 2 quando detectar necessidade de histórico
- ✅ Validar campos obrigatórios: `dt_inicio_vigencia`, `dt_fim_vigencia`, `registro_atual`

---

## 10) Streaming vs. Batch

**Preferência**: usar **streaming** quando fonte permitir (incremental).

```python
# ✅ STREAMING (preferido para incremental)
@dlt.table
def vendas_trusted():
    return dlt.read_stream("bronze.vendas")  # STREAM

# ✅ BATCH (aceitável para full refresh)
@dlt.table
def categorias_trusted():
    return dlt.read("bronze.categorias")  # BATCH (tabela pequena)
```

**O Copilot deve:**
- ✅ **Sugerir** `read_stream()` para tabelas grandes/incrementais
- ✅ Validar que `read()` (batch) só é usado quando apropriado

---

## 11) Revisão Rápida (Checklist para PR)

- [ ] **DLT obrigatório**: usa `@dlt.table` ou `CREATE LIVE TABLE`?
- [ ] **Expectations**: pelo menos 2-3 validações de qualidade definidas?
- [ ] **Schema explícito**: StructType/DDL com comentários em todas as colunas?
- [ ] **Padronização**: CPF, telefone, nomes, emails tratados?
- [ ] **Deduplicação**: estratégia explícita implementada?
- [ ] **Nomenclatura**: segue padrão `tb_{entidade}`?
- [ ] **Campos de controle**: mantém auditoria de Bronze + adiciona Trusted?
- [ ] **Particionamento**: otimizado para padrão de consulta?
- [ ] **Streaming**: usa `read_stream()` quando aplicável?

---

## 12) Anti‑padrões que o Copilot NÃO deve sugerir

- ❌ Transformações Trusted sem DLT (Spark "puro")
- ❌ Tabelas Trusted sem expectations de qualidade
- ❌ Inferência de schema (`.option("inferSchema", "true")`)
- ❌ Colunas sem comentários/descrições
- ❌ Ausência de deduplicação explícita
- ❌ Nomes com prefixo de origem (`sap_`, `api_`) - isso é Bronze
- ❌ Perda de campos de auditoria de Bronze
- ❌ Uso de `mode("overwrite")` sem justificativa (preferir streaming/incremental)

---

## 13) Integração com Outras Instruções

Este arquivo **complementa** (não substitui) as regras de:
- `raw.instructions.md` → campos de auditoria originais
- `python.instructions.md` → cabeçalho, segredos, logging
- `sql-instructions.instructions.md` → qualidade de SQL
- `copilot-instructions.md` → fluxo bronze → trusted → refined

