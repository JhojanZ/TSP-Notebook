#!/bin/bash
# Setup script para reproducir el entorno localmente

echo "🔧 Creando entorno virtual..."
python3 -m venv venv

echo "✅ Activando entorno virtual..."
source venv/bin/activate

echo "📦 Instalando dependencias..."
pip install --upgrade pip
pip install -r requeriment.txt

echo "✨ Entorno listo. Para activar en el futuro ejecuta:"
echo "   source venv/bin/activate"
