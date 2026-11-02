# maintenance.sql
-- Revisión y mantenimiento justificado - Food Store
-- Motor: PostgreSQL 16+
-- Regla: NO usar VACUUM FULL como mantenimiento periódico

-- 1) Revisión previa OBLIGATORIA antes de decidir acción
SELECT schemaname,
       relname AS tabla,
       n_live_tup AS tuplas_vivas,
       n_dead_tup AS tuplas_muertas,
       round(100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS pct_muertas,
       last_autovacuum,
       last_autoanalyze,
       last_vacuum,
       last_analyze
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY n_dead_tup DESC, relname;

-- 2) Acción de mantenimiento segura y justificada
-- Justificación:
-- - ANALYZE actualiza las estadísticas para que el planificador elija planes correctos.
-- - VACUUM (sin FULL) limpia tuplas muertas, recupera espacio reutilizable y permite
--   el congelamiento de XID, sin bloquear lecturas/escrituras de forma exclusiva.
-- - VACUUM FULL reescribe la tabla/índices con AccessExclusiveLock, devuelve espacio
--   al SO pero NO se recomienda para mantenimiento periódico.

-- Ejemplo (ejecutar ÚNICAMENTE si la revisión justifica hacerlo, comentado por defecto):
-- VACUUM (ANALYZE) public.pedido;
-- VACUUM (ANALYZE) public.detalle_pedido;
-- VACUUM (ANALYZE) public.producto;
