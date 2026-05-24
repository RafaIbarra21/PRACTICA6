DROP TABLE IF EXISTS fact_ventas CASCADE;
DROP TABLE IF EXISTS dim_tienda CASCADE;
DROP TABLE IF EXISTS dim_tiempo CASCADE;
DROP TABLE IF EXISTS dim_indicador_economico CASCADE;
DROP TABLE IF EXISTS dim_feriado CASCADE;

CREATE TABLE dim_tienda AS
SELECT
    ROW_NUMBER() OVER (ORDER BY store) AS id_tienda,
    store
FROM (SELECT DISTINCT store FROM raw_walmart_sales) x;

ALTER TABLE dim_tienda ADD PRIMARY KEY (id_tienda);

CREATE TABLE dim_tiempo AS
SELECT
    ROW_NUMBER() OVER (ORDER BY date::date) AS id_tiempo,
    date::date AS fecha,
    EXTRACT(YEAR FROM date::date)::int AS anio,
    EXTRACT(MONTH FROM date::date)::int AS mes,
    EXTRACT(DAY FROM date::date)::int AS dia
FROM (SELECT DISTINCT date FROM raw_walmart_sales) x;

ALTER TABLE dim_tiempo ADD PRIMARY KEY (id_tiempo);

CREATE TABLE dim_feriado AS
SELECT
    ROW_NUMBER() OVER (ORDER BY holiday_flag) AS id_feriado,
    holiday_flag,
    CASE
        WHEN holiday_flag::int = 1 THEN 'Semana con feriado'
        ELSE 'Semana normal'
    END AS tipo_semana
FROM (SELECT DISTINCT holiday_flag FROM raw_walmart_sales) x;

ALTER TABLE dim_feriado ADD PRIMARY KEY (id_feriado);

CREATE TABLE dim_indicador_economico AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY temperature, fuel_price, cpi, unemployment
    ) AS id_indicador,
    temperature::numeric(10, 2) AS temperature,
    fuel_price::numeric(10, 3) AS fuel_price,
    cpi::numeric(10, 4) AS cpi,
    unemployment::numeric(10, 4) AS unemployment
FROM (
    SELECT DISTINCT temperature, fuel_price, cpi, unemployment
    FROM raw_walmart_sales
) x;

ALTER TABLE dim_indicador_economico ADD PRIMARY KEY (id_indicador);

CREATE TABLE fact_ventas AS
SELECT
    ROW_NUMBER() OVER (ORDER BY r.store, r.date::date) AS id_venta,
    ti.id_tienda,
    tm.id_tiempo,
    fe.id_feriado,
    ie.id_indicador,
    r.weekly_sales::numeric(12, 2) AS weekly_sales
FROM raw_walmart_sales r
JOIN dim_tienda ti ON r.store = ti.store
JOIN dim_tiempo tm ON r.date::date = tm.fecha
JOIN dim_feriado fe ON r.holiday_flag = fe.holiday_flag
JOIN dim_indicador_economico ie
    ON r.temperature::numeric(10, 2) = ie.temperature
    AND r.fuel_price::numeric(10, 3) = ie.fuel_price
    AND r.cpi::numeric(10, 4) = ie.cpi
    AND r.unemployment::numeric(10, 4) = ie.unemployment;

ALTER TABLE fact_ventas ADD PRIMARY KEY (id_venta);

ALTER TABLE fact_ventas
ADD CONSTRAINT fk_tienda FOREIGN KEY (id_tienda) REFERENCES dim_tienda(id_tienda),
ADD CONSTRAINT fk_tiempo FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id_tiempo),
ADD CONSTRAINT fk_feriado FOREIGN KEY (id_feriado) REFERENCES dim_feriado(id_feriado),
ADD CONSTRAINT fk_indicador FOREIGN KEY (id_indicador) REFERENCES dim_indicador_economico(id_indicador);