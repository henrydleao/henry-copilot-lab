
# Autor: Fulano
#tabela: tb_stg_faturamento_de_vendas# Data: 2026-01-21
# Objetivo: contrato de dados para staging
# Versão: 0.1
# Histórico de Atualizações:
# 2026-01-21 - Fulano - criação

import pandera.pandas as pa

schema = pa.DataFrameSchema(
    {
       "id_cliente": pa.Column(pa.String, nullable=True),

        "qtd_data": pa.Column(pa.DateTime, nullable=True),

        "num_valor_total": pa.Column(pa.Float, nullable=False),
    }
)

metadata = {
    "area": "Financeiro",
    "sistema": "erp_sap",
    "sub_sistema": None,
    "file_name": "faturamento_de_vendas",
}

# Projeto: veritas
# Camada: raw
