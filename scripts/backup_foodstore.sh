# backup_foodstore.sh
#!/usr/bin/env bash
# Respaldo automatizable de Food Store - PostgreSQL 16+
# NO contiene contraseñas. Usar ~/.pgpass con permisos 600

set -euo pipefail

PGHOST=""
PGPORT=""
PGUSER=""
BASE=""
DESTINO=""
LOGS=""

mkdir -p "" ""

FECHA=""
ARCHIVO="/foodstore_.dump"
PARCIAL=".parcial"
LOGFILE="/backup_foodstore_.log"

log() {
  local msg=" "
  echo ""
  echo "" >> ""
}

log "INICIO - Respaldo custom de "
log "Destino: "

cleanup() {
  rm -f "" 2>/dev/null || true
}
trap cleanup ERR

# 1) pg_dump en formato custom
pg_dump -h "" -p "" -U "" -d "" -Fc -f "" 2>&1 | tee -a ""
log "VERIFICACION - pg_restore --list"
pg_restore --list "" > /dev/null 2>&1

# 3) Renombrado y hash
mv "" ""
sha256sum "" > ".sha256" 2>/dev/null || shasum -a 256 "" > ".sha256"
trap - ERR
TAMANO=""
log "FIN OK -  - Tamaño: "
exit 0
