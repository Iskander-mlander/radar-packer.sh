# 🛰️ RadarLoop-Packer

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)
![Platform: Linux](https://img.shields.io/badge/Platform-Linux-lightgrey.svg)
![Language: Shell](https://img.shields.io/badge/Language-Shell-orange.svg)
![Dependencies: FFmpeg](https://img.shields.io/badge/Dependencies-FFmpeg-green.svg)

**RadarLoop-Packer** es una utilidad de terminal para Linux diseñada para desarrolladores de videojuegos (especialmente aquellos que usan SDL2, Raylib o Love2D). Permite extraer segmentos de vídeo con precisión de milisegundos para crear **Sprite Sheets** matemáticamente perfectos para animaciones en bucle (seamless loops).
Ideal para procesar radares, efectos de partículas, o cualquier asset animado generado por IA (como Luma, Runway o Kling) que no venga loopeado de fábrica.

## 🛠️ El Problema
Los vídeos de internet o generados por IA no suelen terminar donde empiezan. Al animar en un motor 2D, esto causa un "salto" visual molesto. Este script permite encontrar el "Ciclo de Oro" del vídeo y convertirlo en una tira de imágenes (Sprite Sheet) lista para tu motor de juego.

## 🚀 Requisitos
El script utiliza herramientas estándar del ecosistema GNU/Linux:
* `ffmpeg`: Para el procesamiento y recorte de vídeo.
* `imagemagick`: Para la composición del Sprite Sheet final.
* `bc`: Para cálculos matemáticos de precisión en el shell.
* `mpv`: (Recomendado) Como visor ultra-ligero para análisis de frames.

## 📖 Guía de Uso

### 1. Análisis con MPV
Antes de usar el script, abre tu vídeo con `mpv` para identificar los puntos de corte:
* `.` : Avanza un fotograma.
* `,` : Retrocede un fotograma.
* `o` : Muestra el tiempo (OSD) con milisegundos.

En el ejemplo, busca el tiempo de **Inicio** (ej. cuando la aguja del radar está a las 12) y el tiempo de **Fin** (cuando completa la vuelta).

### 2. Ejecución del Script
1. Clona este repositorio.
2. Dale permisos: `chmod +x radar-packer.sh`
3. Ejecuta: `./radar-packer.sh`

### 3. Integración en C/SDL2
El script genera un PNG horizontal. Para animarlo, simplemente desplaza el `source rect` de tu textura:
```c
// Ejemplo rápido
int total_frames = 36; 
int frame_actual = (SDL_GetTicks() / ms_per_frame) % total_frames;
srcrect.x = frame_actual * frame_width;
```

## ⚖️ License (GPL v3)
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.html.

## ❤️ Comunidad
Hecho con amor para la Comunidad Linuxera. 
Porque en el software libre, compartimos las herramientas que nos hacen libres.
¡Si te sirve, dale una ⭐ al repo!
