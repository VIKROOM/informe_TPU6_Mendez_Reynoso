# restore_test.ps1 (opcional)
# Simulacro de restauración contra reloj - Food Store
# Restaurar ÚNICAMENTE en foodstore_restore_test (entorno descartable)
# NO tocar foodstore

param(
  [string]$PgBin = "C:\Program Files\PostgreSQL\16\bin",
  [string]$PgHost = "localhost",
  [int]$PgPort = 5432,
  [string]$PgUser = "postgres",
  [string]$Dump = ".\backups\ULTIMO_RESPALDO.dump",
  [string]$TestDb = "foodstore_restore_test"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Dump)) {
  Write-Error "No se encuentra el dump: $Dump"
  exit 1
}

$inicio = Get-Date
Write-Output "INICIO simulacro - Crear $TestDb y restaurar"

$createdb = Join-Path $PgBin "createdb.exe"
$pgrestore = Join-Path $PgBin "pg_restore.exe"
$psql = Join-Path $PgBin "psql.exe"

& $createdb -h $PgHost -p $PgPort -U $PgUser $TestDb | Out-Null

& $pgrestore -h $PgHost -p $PgPort -U $PgUser -d $TestDb --no-owner --no-privileges $Dump
if ($LASTEXITCODE -ne 0) { throw "pg_restore fallo" }

$sql = @\
SELECT 'categoria' AS tabla, COUNT(*) AS filas FROM categoria
UNION ALL SELECT 'cliente', COUNT(*) FROM cliente
UNION ALL SELECT 'producto', COUNT(*) FROM producto
UNION ALL SELECT 'pedido', COUNT(*) FROM pedido
UNION ALL SELECT 'detalle_pedido', COUNT(*) FROM detalle_pedido;
SELECT COUNT(*) AS productos_invalidos FROM producto WHERE precio < 0 OR stock < 0;
SELECT COUNT(*) AS detalles_invalidos FROM detalle_pedido WHERE cantidad <= 0 OR precio_unitario < 0;
\@

$sql | & $psql -h $PgHost -p $PgPort -U $PgUser -d $TestDb -t -A

$fin = Get-Date
$seg = ($fin - $inicio).TotalSeconds
Write-Output "FIN - RTO_OBSERVADO_SEGUNDOS: $seg"

