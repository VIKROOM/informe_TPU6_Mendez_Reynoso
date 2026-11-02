# health_check.sql
-- Monitoreo y chequeo de salud - Food Store
-- Motor: PostgreSQL 16+

-- 1) Tamaño de la base
SELECT pg_size_pretty(pg_database_size('foodstore')) AS tamano_base;

-- 2) Actividad de conexiones
SELECT numbackends AS conexiones_activas,
       xact_commit AS transacciones_commit,
       xact_rollback AS transacciones_rollback
FROM pg_stat_database
WHERE datname = 'foodstore';

-- 3) Estado de tablas (tuplas vivas/muertas, autovacuum/analyze)
SELECT schemaname,
       relname AS tabla,
       n_live_tup AS tuplas_vivas,
       n_dead_tup AS tuplas_muertas,
       last_autovacuum,
       last_autoanalyze
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC, relname;

-- 4) Consultas activas (distintas a idle)
SELECT pid,
       usename,
       application_name,
       state,
       now() - query_start AS duracion,
       left(query, 150) AS query_preview
FROM pg_stat_activity
WHERE datname = 'foodstore'
  AND pid <> pg_backend_pid()
  AND state <> 'idle'
ORDER BY query_start;
