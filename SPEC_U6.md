# SPEC_U6.md
# Especificación y plan de mantenimiento - Food Store (Unidad 6)

## Propósito
Integrar respaldo, monitoreo, mantenimiento y recuperación sobre la base oodstore. Se construye un procedimiento para generar una copia, registrar métricas, restaurar en un entorno descartable (oodstore_restore_test) y medir el tiempo de recuperación.

## Condiciones de trabajo
- Motor: PostgreSQL 16 o superior
- Base principal: oodstore (NO se elimina ni se reemplaza durante el simulacro)
- Base de restauración: oodstore_restore_test (entorno descartable)
- Respaldos en formato custom (-Fc) para utilizar pg_restore
- Las contraseñas NO se escriben en scripts ni se entregan en el repositorio
- Las pruebas destructivas solo se ejecutan sobre entornos descartables
- VACUUM FULL NO se utiliza como mantenimiento periódico

## Plan de mantenimiento automatizable
| Tarea mínima | Frecuencia propuesta | Evidencia | Condición para considerar terminada |
|--------------|---------------------|-----------|---------------------------------------|
| Respaldo de oodstore | Diaria | Archivo .dump con fecha/hora + log en carpeta logs/ | pg_dump finaliza con código 0, pg_restore --list válido, hash SHA256 generado |
| Chequeo de salud | Diaria | Salida de health_check.sql | Se obtienen tamaño de base, actividad de conexiones, estado de tablas y consultas activas sin errores |
| Revisión de mantenimiento | Semanal | Salida de maintenance.sql | Se revisan tuplas vivas/muertas, last_autovacuum/last_autoanalyze. Si se ejecuta VACUUM/ANALYZE debe estar justificado con la observación previa. No se usa VACUUM FULL. |
| Restauración de prueba | Semanal | oodstore_restore_test validada | Base creada, restaurada con pg_restore, conteos validados vs. pre-respaldo, productos_invalidos=0, detalles_invalidos=0. Se registra RPO/RTO observados. |

## Reglas de seguridad
- No incluir contraseñas en .sql, .ps1 o .sh
- Usar autenticación por pgpass.conf (Windows) o ~/.pgpass con permisos 600 (Linux)
- Ejecutar pruebas destructivas únicamente sobre oodstore_restore_test
- Verificar y probar manualmente antes de programar
- Subordinar el uso de OpenCode a revisión y prueba humana
