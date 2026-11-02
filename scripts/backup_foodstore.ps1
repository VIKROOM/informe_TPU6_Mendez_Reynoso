# backup_foodstore.ps1
# Respaldo automatizable de Food Store - PostgreSQL 16+
# NO contiene contraseñas. Usar pgpass.conf

param(
  [string] = "C:\\Program Files\\PostgreSQL\\16\\bin",
  [string] = "localhost",
  [int] = 5432,
  [string] = "postgres",
  [string] = "foodstore",
  [string] = ".\\backups",
  [string] = ".\\logs"
)

Continue = "Stop"

New-Item -ItemType Directory -Force -Path ,  | Out-Null

 = Get-Date -Format "yyyyMMdd_HHmmss"
 = Join-Path  "foodstore_.dump"
 = ".parcial"
 = Join-Path  "backup_foodstore_.log"

function Log() {
   = "2026-11-02T20:22:54 "
  Write-Output 
  Add-Content -Path  -Value 
}

Log "INICIO - Respaldo custom de "
Log "Destino: "

try {
  # 1) pg_dump en formato custom
  & "\pg_dump.exe" -h  -p  -U  -d  -Fc -f  2>&1 | Tee-Object -FilePath  -Append
  if ( -ne 0) { throw "pg_dump fallo con codigo " }

  # 2) Verificación con pg_restore --list
  Log "VERIFICACION - pg_restore --list"
  & "\pg_restore.exe" --list  2>&1 | Out-Null
  if ( -ne 0) { throw "pg_restore --list fallo. Respaldo posiblemente corrupto." }

  # 3) Renombrado y hash
  Move-Item -Path  -Destination  -Force
   = (Get-FileHash -Path  -Algorithm SHA256).Hash
   | Set-Content -Path ".sha256"
  Log "SHA256: "

   = (Get-Item ).Length
  Log "FIN OK - Archivo:  - Tamaño:  bytes"
  exit 0
}
catch {
  Log "ERROR: "
  if (Test-Path ) { Remove-Item  -Force }
  exit 1
}
