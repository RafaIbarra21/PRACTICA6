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

df = pd.read_csv("walmart_sales_clean.csv")

df.to_sql("raw_walmart_sales", engine, if_exists="replace", index=False)

print("Tabla raw_walmart_sales subida correctamente a Supabase")
print("Registros cargados:", len(df))
