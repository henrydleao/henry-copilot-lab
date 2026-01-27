---
applyTo: "**/*.{py,sql}"
---

# Regras para Camada Refined – Data Lakehouse

Estas instruções se aplicam a **arquivos que criam, modificam ou agregam dados na camada Refined**. O Copilot deve validar modelagem dimensional, otimização e semântica de negócio.

> **Importante**: Aplicar estas regras quando detectar no código ou metadados: `Camada: Refined`, tabelas em schema `refined.*`, ou modelos analíticos/dimensionais.

---

## 1) DLT (Delta Live Tables) Obrigatório

**Toda transformação para Refined DEVE usar Delta Live Tables.**

```python
# ✅ CORRETO - DLT para agregações
import dlt
from pyspark.sql import functions as F

@dlt.table(
    name="refined.fato_vendas_diario",
    comment="Fato de vendas agregado por dia com métricas de negócio",
    table_properties={
        "quality": "platinum",
        "layer": "refined",
        "model_type": "fact_table"
    }
)
def fato_vendas_diario():
    return (
        dlt.read("trusted.tb_vendas")
        .groupBy("dt_venda", "id_produto", "id_cliente")
        .agg(
            F.sum("valor").alias("valor_total"),
            F.count("id_venda").alias("qtd_vendas"),
            F.avg("valor").alias("valor_medio")
        )
    )
```

**O Copilot deve:**
- ❌ **Recusar** código Spark "puro" para transformações de Refined
- ✅ **Exigir** `@dlt.table` ou `CREATE LIVE TABLE`
- ✅ Validar `table_properties` com `layer: refined`

---

## 2) Modelagem Dimensional

**Obrigatório**: seguir princípios de **modelagem dimensional** (Kimball).

### 2.1) Tabelas Fato

```python
# ✅ ESTRUTURA DE TABELA FATO
@dlt.table(name="refined.fato_vendas")
def fato_vendas():
    return dlt.read("trusted.tb_vendas") \
        .join(dlt.read("refined.dim_produto"), ["id_produto"]) \
        .join(dlt.read("refined.dim_cliente"), ["id_cliente"]) \
        .join(dlt.read("refined.dim_tempo"), ["dt_venda"]) \
        .select(
            # Chaves estrangeiras (surrogate keys)
            "sk_produto",
            "sk_cliente", 
            "sk_tempo",
            # Métricas (measures)
            "valor_venda",
            "qtd_itens",
            "valor_desconto",
            # Degenerate dimensions (se necessário)
            "numero_nota_fiscal"
        )
```

**Características de Fato:**
- ✅ Nome: `fato_{processo_negocio}`
- ✅ Contém **métricas numéricas** (valores, quantidades, percentuais)
- ✅ Chaves estrangeiras para dimensões (`sk_*` ou `id_*`)
- ✅ Granularidade bem definida e documentada

### 2.2) Tabelas Dimensão

```python
# ✅ ESTRUTURA DE TABELA DIMENSÃO
@dlt.table(name="refined.dim_produto")
def dim_produto():
    return dlt.read("trusted.tb_produtos") \
        .select(
            # Surrogate key (sequencial, imutável)
            F.monotonically_increasing_id().alias("sk_produto"),
            # Natural key (chave de negócio)
            F.col("id_produto").alias("nk_produto"),
            # Atributos descritivos
            "codigo_sku",
            "nome_produto",
            "descricao",
            "categoria",
            "subcategoria",
            "marca",
            "linha_produto",
            # Metadados SCD
            "dt_inicio_vigencia",
            "dt_fim_vigencia",
            "registro_atual"
        )
```

**Características de Dimensão:**
- ✅ Nome: `dim_{entidade}`
- ✅ Surrogate key (`sk_*`) como chave primária
- ✅ Natural key (`nk_*`) para rastreabilidade
- ✅ Atributos descritivos textuais
- ✅ SCD (Type 1 ou Type 2) quando aplicável

**O Copilot deve:**
- ✅ Validar nomenclatura `fato_*` e `dim_*`
- ✅ **Alertar** quando fato não tiver métricas numéricas
- ✅ **Alertar** quando dimensão não tiver surrogate key
- ✅ **Sugerir** SCD Type 2 em dimensões que variam no tempo

---

## 3) Métricas e Agregações

**Obrigatório**: métricas devem ser **calculadas consistentemente** e **documentadas**.

```python
# ✅ MÉTRICAS BEM DEFINIDAS
@dlt.table(name="refined.metricas_vendas_mensal")
def metricas_vendas():
    return dlt.read("refined.fato_vendas") \
        .groupBy("ano_mes", "categoria_produto") \
        .agg(
            # Métricas aditivas
            F.sum("valor_venda").alias("receita_total"),
            F.sum("qtd_itens").alias("qtd_total_vendida"),
            F.count("id_venda").alias("qtd_transacoes"),
            
            # Métricas semi-aditivas (média ponderada)
            (F.sum("valor_venda") / F.sum("qtd_itens")).alias("ticket_medio"),
            
            # Métricas derivadas
            F.countDistinct("id_cliente").alias("clientes_unicos"),
            F.max("valor_venda").alias("maior_venda"),
            F.min("valor_venda").alias("menor_venda"),
            
            # Percentis (quando necessário)
            F.expr("percentile_approx(valor_venda, 0.5)").alias("mediana_venda")
        )
```

**O Copilot deve:**
- ✅ **Validar** que agregações usam funções corretas (`sum`, `avg`, `count`)
- ✅ **Alertar** sobre divisões sem tratamento de zero
- ✅ **Sugerir** aliases descritivos para métricas calculadas
- ✅ **Validar** coerência de granularidade no `groupBy`

---

## 4) Nomenclatura Semântica

**Padrão obrigatório**: nomes devem refletir **conceitos de negócio**.

```sql
-- ✅ NOMENCLATURA REFINADA (conceitos de negócio)
CREATE LIVE TABLE refined.fato_vendas
CREATE LIVE TABLE refined.dim_cliente
CREATE LIVE TABLE refined.dim_produto
CREATE LIVE TABLE refined.dim_tempo
CREATE LIVE TABLE refined.metricas_performance_vendas

-- ❌ EVITAR (nomenclatura técnica em Refined)
CREATE LIVE TABLE refined.tb_vendas_agg
CREATE LIVE TABLE refined.vendas_grouped
CREATE LIVE TABLE refined.temp_metrics
```

**Padrões por tipo:**
- **Fatos**: `fato_{processo_negocio}` (ex: `fato_vendas`, `fato_estoque`)
- **Dimensões**: `dim_{entidade}` (ex: `dim_cliente`, `dim_tempo`)
- **Métricas**: `metricas_{contexto}` (ex: `metricas_financeiras_mensal`)
- **Views de negócio**: `vw_{area}_{finalidade}` (ex: `vw_comercial_dashboard`)

**O Copilot deve:**
- ✅ Validar padrão `fato_*`, `dim_*`, `metricas_*`, `vw_*`
- ❌ **Alertar** sobre nomes técnicos (`tb_`, `agg_`, `temp_`)

---

## 5) Otimização de Performance

**Obrigatório**: aplicar técnicas de otimização para consultas analíticas.

### 5.1) Z-ORDER (Liquid Clustering)

```sql
-- ✅ Z-ORDER para colunas frequentemente filtradas
CREATE OR REFRESH LIVE TABLE refined.fato_vendas
CLUSTER BY (dt_venda, id_produto, id_cliente)
```

```python
# ✅ Z-ORDER via código
@dlt.table(
    name="refined.fato_vendas",
    table_properties={
        "delta.autoOptimize.optimizeWrite": "true",
        "delta.autoOptimize.autoCompact": "true"
    }
)
```

### 5.2) Particionamento Estratégico

```sql
-- ✅ Particionar por dimensão de tempo
PARTITIONED BY (ano_mes)
```

### 5.3) Estatísticas e Vacuum

```python
# ✅ Manutenção regular (em jobs separados)
spark.sql("OPTIMIZE refined.fato_vendas ZORDER BY (dt_venda)")
spark.sql("ANALYZE TABLE refined.fato_vendas COMPUTE STATISTICS")
spark.sql("VACUUM refined.fato_vendas RETAIN 168 HOURS")  # 7 dias
```

**O Copilot deve:**
- ✅ **Sugerir** Z-ORDER/CLUSTER BY para tabelas grandes
- ✅ **Sugerir** particionamento por data em fatos volumosos
- ✅ **Recomendar** autoOptimize em table_properties

---

## 6) Documentação Rica de Negócio

**Obrigatório**: comentários devem usar **linguagem de negócio**, não técnica.

```sql
-- ✅ COMENTÁRIOS DE NEGÓCIO
CREATE LIVE TABLE refined.fato_vendas (
  sk_produto BIGINT COMMENT 'Chave da dimensão Produto',
  sk_cliente BIGINT COMMENT 'Chave da dimensão Cliente',
  valor_venda DECIMAL(12,2) COMMENT 'Valor total da venda incluindo impostos',
  qtd_itens INT COMMENT 'Quantidade de itens vendidos na transação',
  margem_bruta DECIMAL(12,2) COMMENT 'Margem bruta: receita - custo do produto',
  indicador_primeira_compra BOOLEAN COMMENT 'Indica se é a primeira compra do cliente'
)
COMMENT 'Fato de vendas com granularidade de transação. Atualizado em tempo real via streaming. Fonte: Trusted.tb_vendas.'
```

**O Copilot deve:**
- ✅ **Validar** que comentários usam termos de negócio
- ✅ **Sugerir** documentar: granularidade, fonte, frequência de atualização
- ❌ **Alertar** sobre comentários técnicos demais

---

## 7) Dimensão Tempo (Obrigatória)

**Obrigatório**: criar dimensão `dim_tempo` para análises temporais.

```python
# ✅ DIMENSÃO TEMPO COMPLETA
@dlt.table(name="refined.dim_tempo")
def dim_tempo():
    from pyspark.sql import functions as F
    from datetime import datetime, timedelta
    
    # Gerar série temporal
    start = datetime(2020, 1, 1)
    end = datetime(2030, 12, 31)
    dates = [(start + timedelta(days=x),) for x in range((end - start).days + 1)]
    
    df = spark.createDataFrame(dates, ["data"])
    
    return df.select(
        F.monotonically_increasing_id().alias("sk_tempo"),
        F.col("data"),
        F.year("data").alias("ano"),
        F.month("data").alias("mes"),
        F.dayofmonth("data").alias("dia"),
        F.dayofweek("data").alias("dia_semana"),
        F.weekofyear("data").alias("semana_ano"),
        F.quarter("data").alias("trimestre"),
        F.date_format("data", "MMMM").alias("nome_mes"),
        F.date_format("data", "EEEE").alias("nome_dia_semana"),
        (F.dayofweek("data").isin([1, 7])).alias("fim_semana"),
        # Adicionar feriados se necessário
        F.when(F.col("data").isin(feriados), True).otherwise(False).alias("feriado")
    )
```

**O Copilot deve:**
- ✅ **Alertar** se não existir `dim_tempo` em projetos com fatos temporais
- ✅ **Sugerir** atributos mínimos: ano, mês, dia, trimestre, dia_semana

---

## 8) Joins e Relacionamentos

**Obrigatório**: joins devem ser **explícitos** e **documentados**.

```python
# ✅ JOINS EXPLÍCITOS E DOCUMENTADOS
@dlt.table(name="refined.fato_vendas_completo")
def fato_vendas_completo():
    vendas = dlt.read("trusted.tb_vendas")
    produtos = dlt.read("refined.dim_produto")
    clientes = dlt.read("refined.dim_cliente")
    
    return vendas \
        .join(produtos, vendas.id_produto == produtos.nk_produto, "inner") \
        .join(clientes, vendas.id_cliente == clientes.nk_cliente, "inner") \
        .select(
            produtos["sk_produto"],
            clientes["sk_cliente"],
            vendas["*"]
        )
```

**O Copilot deve:**
- ✅ Validar que joins usam chaves explícitas (não cross join acidental)
- ✅ **Alertar** sobre `join` sem segundo parâmetro (pode gerar cartesiano)
- ✅ **Sugerir** broadcast hint para dimensões pequenas

---

## 9) Views de Negócio

**Recomendado**: criar views para simplificar consumo.

```sql
-- ✅ VIEW DE NEGÓCIO
CREATE OR REPLACE VIEW refined.vw_vendas_consolidado AS
SELECT 
  d.data,
  d.ano,
  d.mes,
  p.categoria AS categoria_produto,
  p.marca,
  c.segmento AS segmento_cliente,
  c.regiao,
  SUM(f.valor_venda) AS receita_total,
  COUNT(f.id_venda) AS qtd_vendas,
  AVG(f.valor_venda) AS ticket_medio
FROM refined.fato_vendas f
INNER JOIN refined.dim_tempo d ON f.sk_tempo = d.sk_tempo
INNER JOIN refined.dim_produto p ON f.sk_produto = p.sk_produto
INNER JOIN refined.dim_cliente c ON f.sk_cliente = c.sk_cliente
WHERE d.ano >= YEAR(CURRENT_DATE()) - 2
GROUP BY d.data, d.ano, d.mes, p.categoria, p.marca, c.segmento, c.regiao
```

**O Copilot deve:**
- ✅ **Sugerir** views para consultas complexas recorrentes
- ✅ Validar que views usam `CREATE OR REPLACE`
- ✅ **Recomendar** filtros de performance (ex: últimos 2 anos)

---

## 10) Testes de Qualidade

**Obrigatório**: validar integridade referencial e métricas.

```python
# ✅ TESTES DE QUALIDADE EM REFINED
@dlt.table(name="refined.fato_vendas")
@dlt.expect_or_fail("fk_produto_valida", "sk_produto IS NOT NULL")
@dlt.expect_or_fail("fk_cliente_valida", "sk_cliente IS NOT NULL")
@dlt.expect_or_fail("valor_positivo", "valor_venda > 0")
@dlt.expect("metrica_coerente", "qtd_itens > 0")
def fato_vendas():
    return ...
```

**O Copilot deve:**
- ✅ **Exigir** expectations de chaves estrangeiras (NOT NULL)
- ✅ **Sugerir** validações de coerência (valor > 0, datas válidas)
- ✅ **Alertar** se métricas puderem gerar NULL/divisão por zero

---

## 11) Revisão Rápida (Checklist para PR)

- [ ] **DLT obrigatório**: usa `@dlt.table` ou `CREATE LIVE TABLE`?
- [ ] **Modelagem dimensional**: segue padrão `fato_*` e `dim_*`?
- [ ] **Surrogate keys**: dimensões têm `sk_*` como PK?
- [ ] **Métricas documentadas**: agregações com aliases descritivos?
- [ ] **Nomenclatura de negócio**: nomes refletem conceitos (não técnicos)?
- [ ] **Otimização**: Z-ORDER/CLUSTER BY definido para tabelas grandes?
- [ ] **Documentação rica**: comentários em linguagem de negócio?
- [ ] **Dimensão tempo**: existe `dim_tempo` para análises temporais?
- [ ] **Joins explícitos**: relacionamentos documentados e corretos?
- [ ] **Expectations**: validações de integridade referencial?

---

## 12) Anti‑padrões que o Copilot NÃO deve sugerir

- ❌ Transformações Refined sem DLT
- ❌ Fatos sem métricas numéricas (apenas chaves)
- ❌ Dimensões sem surrogate key (`sk_*`)
- ❌ Nomenclatura técnica (`tb_`, `agg_`, `temp_`)
- ❌ Joins sem condição explícita (cross join acidental)
- ❌ Divisões sem tratamento de zero
- ❌ Tabelas grandes sem otimização (Z-ORDER/particionamento)
- ❌ Comentários técnicos em vez de linguagem de negócio
- ❌ Análises temporais sem dimensão tempo
- ❌ Métricas sem validação de qualidade

---

## 13) Integração com Outras Instruções

Este arquivo **complementa** (não substitui) as regras de:
- `raw.instructions.md` → auditoria inicial
- `trusted.instructions.md` → padronização e qualidade
- `python.instructions.md` → cabeçalho, logging
- `sql-instructions.instructions.md` → qualidade de SQL
- `copilot-instructions.md` → fluxo completo

