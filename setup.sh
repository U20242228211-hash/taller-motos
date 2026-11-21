#!/usr/bin/env bash
# Prepara el proyecto en macOS / Linux: crea .venv, instala librerías, copia .env y crea la base con sus datos
set -e
cd "$(dirname "$0")"

echo "→ Creando entorno virtual .venv"
python3 -m venv .venv

echo "→ Instalando librerías"
.venv/bin/python -m pip install --upgrade pip -q
.venv/bin/python -m pip install -r requirements-dev.txt -q

if [ ! -f .env ]; then
  cp .env.example .env
  echo "→ Se creó el archivo .env (con Postgres.app no hay que cambiar nada)"
fi

echo "→ Creando la base taller_motos_db y cargando los datos"
createdb -U postgres taller_motos_db 2>/dev/null || echo "  (la base ya existía)"
psql -U postgres -d taller_motos_db -q -f database/01_creacion.sql
psql -U postgres -d taller_motos_db -q -f database/02_carga.sql

echo ""
echo "Listo. Para iniciar la aplicación:"
echo "  source .venv/bin/activate"
echo "  python app.py"
echo "y abre http://127.0.0.1:5001"
