import os

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine


load_dotenv()

engine = create_engine(
    f"postgresql+psycopg2://{os.getenv('DB_USER')}:{os.getenv('DB_PASSWORD')}"
    f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}",
    connect_args={"sslmode": "require"},
)

query = """
SELECT store, SUM(ventas_totales) AS ventas
FROM data_mart_ventas
GROUP BY store
ORDER BY ventas DESC
LIMIT 10;
"""

ventas_tienda = pd.read_sql(query, engine)
print(ventas_tienda)