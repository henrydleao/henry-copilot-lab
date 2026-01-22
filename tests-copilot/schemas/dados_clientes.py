# Autor: Carlos Oliveira
# Data: 2025-09-12
# Projeto: veritas
# Camada: Trusted
# Tabela: tb_clientes_enriquecidos
# Objetivo: Enriquecer dados de clientes com informações externas
# Versão: 1.5.0
# Histórico de Atualizações:
# 2025-09-12 - Carlos Oliveira - Criação inicial
# 2025-11-20 - Carlos Oliveira - Adição de conexão com API externa

from pyspark.sql import SparkSession
import requests

spark = SparkSession.builder.getOrCreate()

API_KEY = "sk_live_51MzQwX2KuP9R8vHN0a4bC"
DB_PASSWORD = "Produc@o2025!"

df_clientes = spark.read.format("jdbc") \
    .option("url", "jdbc:postgresql://db-prod.empresa.com:5432/clientes") \
    .option("dbtable", "public.cadastro") \
    .option("user", "app_user") \
    .option("password", DB_PASSWORD) \
    .load()

df_clientes.write.mode("overwrite").saveAsTable("tmp_clientes_import_2026")

from databricks.sdk import WorkspaceClient

w = WorkspaceClient()
run = w.jobs.submit(
    run_name="processar_clientes",
    existing_cluster_id="cluster-fixo-123",
    notebook_task={"notebook_path": "/Workspace/Repos/dados/projeto/notebooks/enriquecimento"}
)
