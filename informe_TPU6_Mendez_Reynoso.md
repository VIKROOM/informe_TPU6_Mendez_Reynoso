# informe_TPU6_Mendez_Reynoso
# TP UNIDAD 6 - Mantenimiento, respaldo y recuperación | Food Store

## Alumno
Joaquin Antonio Mendez Reynoso

## 1) Especificación y plan de mantenimiento
| Tarea mínima | Frecuencia propuesta | Evidencia | Condición para considerar terminada |
|--------------|---------------------|-----------|---------------------------------------|
| Respaldo de foodstore | Diaria | Archivo .dump con fecha/hora + log | pg_dump OK, pg_restore --list OK, SHA256 registrado |
| Chequeo de salud | Diaria | health_check.sql | Tamaño, conexiones, estado de tablas, consultas activas |
| Revisión de mantenimiento | Semanal | maintenance.sql | Revisión previa, acción segura justificada, sin VACUUM FULL |
| Restauración de prueba | Semanal | foodstore_restore_test validada | Conteos coincidentes, productos_invalidos=0, detalles_invalidos=0, RPO/RTO registrados |

## 2) Respaldo automatizable
Comando base:
`
pg_dump -h localhost -p 5432 -U postgres -d foodstore -Fc -f backups/foodstore_FECHA_HORA.dump
`
Scripts entregados: backup_foodstore.ps1 / backup_foodstore.sh. Sin contraseñas (pgpass.conf/.pgpass). Verificación con pg_restore --list. Registro en logs.

## 3) Monitoreo y mantenimiento
- health_check.sql: tamaño base, conexiones, pg_stat_user_tables, pg_stat_activity
- maintenance.sql: revisión obligatoria + acción segura (VACUUM (ANALYZE)) justificada. VACUUM FULL no utilizado.

## 4) Simulacro de desastre contra reloj
`
createdb -h localhost -p 5432 -U postgres foodstore_restore_test
pg_restore -h localhost -p 5432 -U postgres -d foodstore_restore_test --no-owner --no-privileges backups/ULTIMO_RESPALDO.dump
`
Validaciones:
- Conteos por tabla validados contra pre-respaldo
- productos_invalidos = 0
- detalles_invalidos = 0
- RPO: 24 h | RTO: 12 min

## 5) Uso de OpenCode
Parte asistida: generación de estructura de scripts siguiendo SPEC_U6.md. Verificación antes de aceptar: lectura línea por línea, sin contraseñas, comandos validados, pruebas en entorno descartable (foodstore_restore_test), uso subordinado a revisión y prueba humana.



## Repositorio Git
[https://github.com/VIKROOM/informe_TPU6_Mendez_Reynoso](https://github.com/VIKROOM/informe_TPU6_Mendez_Reynoso)
