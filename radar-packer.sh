#!/bin/bash

###############################################################################
# LEYENDA TÉCNICA: GENERADOR DE SPRITESHEETS PARA BUCLES PERFECTOS
###############################################################################
# OBJETIVO: 
#   Crear un asset de animación (PNG) optimizado para C/SDL2 a partir de 
#   un vídeo o GIF, asegurando un bucle (loop) matemáticamente perfecto.
#
# DEFINICIÓN DEL PROBLEMA:
#   Los vídeos de IA o internet no suelen terminar donde empiezan. Al animar
#   en SDL2, esto causa un "salto" visual. Necesitamos un segmento donde
#   el primer y el último frame sean consecutivos en el ciclo de movimiento.
#
# TÉCNICAS USADAS:
#   1. Extracción de precisión milimétrica (-ss y -t en FFmpeg).
#   2. Normalización de escala y aspecto (Filtros scale y crop).
#   3. Composición de tira binaria (ImageMagick Montage).
#
# USO DE MPV PARA ANÁLISIS:
#   Para hallar los tiempos exactos, abre tu archivo con: mpv archivo.mp4
#   TECLAS CLAVE:
#     - [ . ] Avanzar un fotograma.
#     - [ , ] Retroceder un fotograma.
#     - [ o ] Mostrar tiempo transcurrido (OSD) con milisegundos.
#     - [ Espacio ] Pausa / Play.
###############################################################################

# Comprobar dependencias
if ! command -v ffmpeg &> /dev/null || ! command -v magick &> /dev/null; then
    echo "Error: Se requieren ffmpeg e imagemagick instalados."
    exit 1
fi

# 1. Entrada de archivo
read -p "Introduce el nombre del archivo (ej. radar.mp4 o anim.gif): " INPUT_FILE
if [ ! -f "$INPUT_FILE" ]; then
    echo "Archivo no encontrado."
    exit 1
fi

# 2. Pre-visualización con tiempo (Opcional pero útil)
echo "-------------------------------------------------------"
echo "Generando previsualización con reloj para análisis..."
PREVIEW_FILE="preview_timer.mp4"
ffmpeg -y -i "$INPUT_FILE" -vf "drawtext=text='%{pts\:hms}':x=(w-tw)/2:y=h-(2*th):fontsize=40:fontcolor=white:box=1:boxcolor=black@0.5" -c:a copy "$PREVIEW_FILE" &> /dev/null
echo "Hecho. Abre '$PREVIEW_FILE' con MPV para ver los tiempos."
echo "-------------------------------------------------------"

# 3. Captura de tiempos
echo "Introduce los tiempos en formato SEGUNDOS.MILISEGUNDOS (ej. 2.250)"
read -p "Tiempo de INICIO del bucle: " T_START
read -p "Tiempo de FINAL del bucle: " T_END

# Calcular duración exacta (usando bc para decimales)
T_DURATION=$(echo "$T_END - $T_START" | bc)

echo "Procesando ciclo de $T_DURATION segundos..."

# 4. Procesamiento y creación de Spritesheet
# Usamos 12 fps por defecto para un buen equilibrio peso/fluidez
OUTPUT_NAME="${INPUT_FILE%.*}_spritesheet.png"

ffmpeg -i "$INPUT_FILE" -ss "$T_START" -t "$T_DURATION" \
    -vf "fps=12,scale=512:512:force_original_aspect_ratio=increase,crop=512:512,setsar=1" \
    -f image2pipe -vcodec ppm - | \
    magick montage - -tile x1 -geometry +0+0 -background none "$OUTPUT_NAME"

if [ $? -eq 0 ]; then
    echo "-------------------------------------------------------"
    echo "¡ÉXITO! Spritesheet generado: $OUTPUT_NAME"
    identify "$OUTPUT_NAME"
    echo "Recuerda: Si el primer y último frame son idénticos, "
    echo "borra el último en GIMP para evitar el micro-parón."
    echo "-------------------------------------------------------"
else
    echo "Hubo un error en el procesamiento."
fi
