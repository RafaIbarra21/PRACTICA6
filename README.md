# PRACTICA6

Subir Walmart Dataset a Supabase y construir un Data Warehouse + Data Mart.

## Flujo de la practica

1. Guardar `walmart_sales.csv` en la raiz del proyecto.
2. Ejecutar `01_validar_dataset.py` para limpiar el dataset.
3. Ejecutar `02_subir_raw_supabase.py` para subir `raw_walmart_sales`.
4. Ejecutar `03_crear_datawarehouse.sql` en Supabase SQL Editor.
5. Ejecutar `04_crear_datamart.sql` en Supabase SQL Editor.
6. Ejecutar `05_consultas_analiticas.py`.
7. Ejecutar `06_graficas.py`.

## Seguridad

El archivo `.env` contiene credenciales privadas y no debe subirse a GitHub.
Usa `.env.example` como plantilla.
