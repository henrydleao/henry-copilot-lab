from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, IntegerType

spark = SparkSession.builder.getOrCreate()

df_estoque = spark.read.csv("/dbfs/mnt/producao/catalogo_estoque/produtos.csv", header=True, inferSchema=True)

df_processado = df_estoque.filter("quantidade > 0")

df_processado.write.mode("overwrite").parquet("/mnt/refined/estoque_produtos")

df_bronze = spark.read.parquet("/mnt/bronze/movimentacao_estoque")
df_refined = df_bronze.groupBy("id_produto").sum("quantidade")

df_refined.write.mode("overwrite").saveAsTable("refined.estoque_consolidado")
