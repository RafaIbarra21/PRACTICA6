import os

import matplotlib.pyplot as plt
import pandas as pd
from dotenv import load_dotenv
from matplotlib.ticker import FuncFormatter
from sqlalchemy import create_engine


load_dotenv()

engine = create_engine(
    f"postgresql+psycopg2://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}"
    f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}",
    connect_args={"sslmode": "require"},
)

df = pd.read_sql("SELECT * FROM data_mart_ventas", engine)


def formato_millones(valor, _):
    return f"${valor / 1_000_000:.1f}M"


# Grafica 1: Top 10 tiendas por ventas
ventas_tienda = (
    df.groupby("store")["ventas_totales"]
    .sum()
    .sort_values(ascending=True)
    .tail(10)
)

plt.figure(figsize=(9, 5))
ax = ventas_tienda.plot(kind="barh", color="#2E86AB")
ax.xaxis.set_major_formatter(FuncFormatter(formato_millones))
plt.title("Top 10 tiendas por ventas totales")
plt.xlabel("Ventas totales")
plt.ylabel("Tienda")
plt.tight_layout()
plt.savefig("ventas_por_tienda.png", dpi=150)
plt.show()


# Grafica 2: Ventas por tipo de semana
ventas_tipo_semana = (
    df.groupby("tipo_semana")["ventas_totales"]
    .sum()
    .sort_values(ascending=False)
)

plt.figure(figsize=(7, 5))
ax = ventas_tipo_semana.plot(kind="bar", color=["#F18F01", "#2E86AB"])
ax.yaxis.set_major_formatter(FuncFormatter(formato_millones))
plt.title("Ventas totales por tipo de semana")
plt.xlabel("Tipo de semana")
plt.ylabel("Ventas totales")
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig("ventas_por_tipo_semana.png", dpi=150)
plt.show()