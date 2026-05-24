DROP TABLE IF EXISTS data_mart_ventas;

CREATE TABLE data_mart_ventas AS
SELECT
    ti.store,
    tm.anio,
    tm.mes,
    fe.tipo_semana,
    SUM(f.weekly_sales) AS ventas_totales,
    AVG(f.weekly_sales) AS venta_promedio,
    COUNT(*) AS semanas_registradas,
    AVG(ie.temperature) AS temperatura_promedio,
    AVG(ie.fuel_price) AS precio_combustible_promedio,
    AVG(ie.cpi) AS cpi_promedio,
    AVG(ie.unemployment) AS desempleo_promedio
FROM fact_ventas f
JOIN dim_tienda ti ON f.id_tienda = ti.id_tienda
JOIN dim_tiempo tm ON f.id_tiempo = tm.id_tiempo
JOIN dim_feriado fe ON f.id_feriado = fe.id_feriado
JOIN dim_indicador_economico ie ON f.id_indicador = ie.id_indicador
GROUP BY ti.store, tm.anio, tm.mes, fe.tipo_semana;

SELECT * FROM data_mart_ventas LIMIT 10;