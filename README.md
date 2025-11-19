# Plataformero 3D

Proyecto de plataformero 3D desarrollado en Godot 4.5 con renderizador Forward+. Este juego presenta un personaje que debe navegar por un nivel 3D recolectando monedas mientras evita caer al vacío.

## 📋 Información del Proyecto

**Versión:** 1.0  
**Motor:** Godot Engine 4.5  
**Renderizador:** Forward Plus  
**Lenguaje:** GDScript  
**Plataforma:** Multiplataforma (Windows, macOS, Linux)

## 🎮 Características

- **Controlador de personaje avanzado**
  - Movimiento fluido en 8 direcciones
  - Sistema de salto mejorado (fuerza de salto: 12)
  - Doble salto implementado
  - Física realista con gravedad

- **Sistema de recolección de monedas**
  - 69 monedas distribuidas estratégicamente en el nivel
  - Animaciones de rotación y flotación
  - Efectos de partículas al recolectar
  - Sonidos de recolección

- **Cámara en tercera persona**
  - Seguimiento suave del jugador
  - Rotación horizontal y vertical
  - Sistema de zoom configurable
  - Seguimiento adaptativo durante saltos altos

- **Diseño de nivel amplio**
  - Layout expandido en todas las direcciones (X, Y, Z)
  - Más de 80 plataformas de diferentes tamaños
  - Múltiples rutas y plataformas laterales
  - Variedad de tipos de plataformas (small, medium, large, xlarge, thick, 1x1)

- **Interfaz de usuario completa**
  - Contador de monedas en tiempo real
  - Contador de tiempo transcurrido
  - Panel de información con fondo semitransparente
  - Iconos SVG personalizados

- **Sistema de límites del mundo**
  - WorldBoundaryShape3D para prevenir caídas infinitas
  - Sistema de respawn automático

- **Soporte para gamepad**
  - Controles completos con mando
  - Rotación de cámara con stick derecho
  - Zoom con gatillos

## 🎯 Controles

### Teclado

**Movimiento:**
- **W, A, S, D** o **Flechas direccionales**: Mover el personaje en 8 direcciones
- **Espacio**: Salto (simple y doble salto)

**Cámara:**
- **Q, E** o **Flechas del teclado numérico (4, 6, 8, 2)**: Rotar cámara horizontal y verticalmente
- **+ / -** (teclado numérico): Zoom in / Zoom out

### Gamepad

**Movimiento:**
- **Stick izquierdo**: Mover el personaje
- **Botón A / X**: Salto

**Cámara:**
- **Stick derecho**: Rotar cámara
- **Gatillos (LT/RT o L2/R2)**: Zoom in / Zoom out

## 🏗️ Arquitectura del Proyecto

### Diseño General

El proyecto sigue una arquitectura modular donde cada componente tiene una responsabilidad específica:

- **Player (CharacterBody3D)**: Maneja movimiento, física y recolección
- **View (Node3D)**: Controla la cámara en tercera persona
- **Coin (Area3D)**: Detecta colisiones y maneja animaciones
- **HUD (Control)**: Actualiza la interfaz de usuario
- **Audio (Autoload)**: Gestiona reproducción de sonidos

### Sistema de Comunicación

El proyecto usa el sistema de señales de Godot para comunicación entre componentes:
- `coin_collected`: Emitida por Player cuando recolecta una moneda, recibida por HUD
- `body_entered`: Emitida por Area3D de las monedas cuando el jugador entra en contacto

### Flujo de Datos

1. **Input del usuario** → Player.handle_controls()
2. **Física y movimiento** → Player._physics_process()
3. **Detección de colisiones** → Coin._on_body_entered()
4. **Actualización de UI** → HUD._on_coin_collected()
5. **Seguimiento de cámara** → View._physics_process()

## 📁 Estructura del Proyecto

```
Plataformero 3D/
├── scenes/                    # Escenas del juego
│   ├── main.tscn             # Escena principal del nivel
│   ├── main-environment.tres # Configuración del ambiente
│   ├── player/
│   │   └── player.tscn       # Escena del jugador
│   ├── items/
│   │   └── coin.tscn        # Escena de moneda
│   └── enemies/              # (Reservado para futuros enemigos)
│
├── scripts/                   # Scripts GDScript
│   ├── player.gd            # Controlador del jugador
│   ├── view.gd              # Controlador de cámara
│   ├── coin.gd              # Lógica de monedas
│   ├── hud.gd               # Interfaz de usuario
│   ├── audio.gd             # Sistema de audio (Autoload)
│   └── main.gd              # Script principal de la escena
│
├── models/                   # Modelos 3D
│   ├── player/
│   │   └── Astronaut_FinnTheFrog.gltf
│   ├── items/
│   │   └── Pickup_Sphere.gltf
│   ├── platforms/           # Modelos de plataformas KayKit
│   │   ├── platform_*_blue.gltf
│   │   └── ...
│   └── environment/         # Elementos decorativos
│       ├── Planet_*.gltf
│       ├── Rock_*.gltf
│       └── Plant_*.gltf
│
├── objects/                  # Objetos reutilizables
│   ├── character.tscn       # Modelo del personaje
│   ├── coin.gd              # Script de moneda
│   └── platform_kaykit_*.tscn  # Escenas de plataformas
│
├── sprites/                  # Texturas y sprites
│   ├── coin_icon.svg        # Icono de moneda para HUD
│   ├── blob_shadow.png      # Sombra del jugador
│   └── particle.png         # Textura de partículas
│
├── sounds/                   # Archivos de audio
│   ├── jump.ogg
│   ├── land.ogg
│   ├── coin.ogg
│   └── walking.ogg
│
├── fonts/                    # Fuentes
│   └── lilita_one_regular.ttf
│
├── materials/                 # Materiales del proyecto
│
├── icon.svg                  # Icono del proyecto
├── splash-screen.svg         # Pantalla de inicio
├── project.godot            # Configuración del proyecto
└── README.md                # Este archivo
```

## 🚀 Cómo Ejecutar el Proyecto

### Requisitos Previos

- **Godot Engine 4.5** o superior
- Sistema operativo compatible (Windows, macOS, Linux)
- Tarjeta gráfica compatible con OpenGL 3.3 o superior

### Pasos para Ejecutar

1. **Descargar Godot 4.5**
   - Descargar desde el sitio oficial: https://godotengine.org/download
   - Seleccionar la versión estándar (no .NET)

2. **Abrir el Proyecto**
   - Abrir Godot Engine
   - Hacer clic en "Importar" o "Abrir"
   - Navegar a la carpeta del proyecto
   - Seleccionar el archivo `project.godot`
   - Hacer clic en "Abrir"

3. **Esperar la Importación**
   - Godot importará automáticamente todos los assets
   - Los modelos GLTF se procesarán automáticamente
   - Esto puede tomar unos minutos la primera vez

4. **Ejecutar el Juego**
   - Presionar **F5** o hacer clic en el botón "Play" (▶️)
   - El juego se ejecutará en una ventana nueva
   - Para detener, presionar **F8** o cerrar la ventana

### Verificar Configuración

Antes de ejecutar, verificar que:
- El renderizador esté configurado como "Forward Plus"
- La escena principal sea `scenes/main.tscn`
- Todos los assets estén importados correctamente (sin errores en el panel de importación)

## 🛠️ Desarrollo

### Tecnologías Utilizadas

- **Godot Engine 4.5**: Motor de juego
- **GDScript**: Lenguaje de programación principal
- **GLTF 2.0**: Formato de modelos 3D
- **Forward+ Rendering**: Renderizador avanzado

### Scripts Principales

**player.gd**
- Maneja movimiento, física y recolección
- Implementa sistema de salto (simple y doble)
- Gestiona animaciones y efectos visuales
- Detecta colisiones con el suelo

**view.gd**
- Controla cámara en tercera persona
- Implementa seguimiento suave del jugador
- Maneja rotación y zoom
- Sistema de seguimiento adaptativo

**coin.gd**
- Detecta colisiones con el jugador
- Maneja animaciones de rotación y flotación
- Reproduce efectos y sonidos
- Gestiona desaparición de la moneda

**hud.gd**
- Actualiza contador de monedas
- Calcula y muestra tiempo transcurrido
- Formatea tiempo en minutos:segundos

**audio.gd** (Autoload)
- Sistema de pool de reproductores de audio
- Permite múltiples sonidos simultáneos
- Gestiona reproducción de efectos de sonido

### Configuración del Proyecto

El archivo `project.godot` contiene:
- Nombre del proyecto: "Plataformero 3D"
- Versión de Godot: 4.5
- Renderizador: Forward Plus
- Escena principal: `scenes/main.tscn`
- Autoload: Audio system

### Importación de Assets

Los modelos GLTF se importan automáticamente cuando se abre el proyecto. Si necesitas reimportar:
1. Seleccionar el archivo en el FileSystem
2. En el Inspector, hacer clic en "Reimport"
3. Ajustar configuraciones si es necesario
4. Guardar

### Personalización

**Ajustar Velocidad del Jugador:**
- Editar `movement_speed` en `scripts/player.gd` (valor actual: 250)

**Ajustar Fuerza del Salto:**
- Editar `jump_strength` en `scripts/player.gd` (valor actual: 12)

**Ajustar Cámara:**
- Editar propiedades en `scripts/view.gd`:
  - `zoom_minimum` y `zoom_maximum`: Límites de zoom
  - `rotation_speed`: Velocidad de rotación
  - `follow_speed`: Velocidad de seguimiento

**Agregar Más Monedas:**
- Instanciar `scenes/items/coin.tscn` en `scenes/main.tscn`
- Posicionar en las coordenadas deseadas

## 📊 Estadísticas del Proyecto

- **Plataformas:** 80+ plataformas de diferentes tamaños
- **Monedas:** 69 monedas distribuidas en el nivel
- **Tipos de Plataformas:** 6 tipos diferentes
- **Scripts:** 6 scripts principales
- **Escenas:** 3 escenas principales + múltiples objetos reutilizables

## 🎨 Assets Utilizados

- **Personaje:** Astronaut_FinnTheFrog.gltf (nuevos assets)
- **Monedas:** Pickup_Sphere.gltf (nuevos assets)
- **Plataformas:** KayKit Platformer Pack (modelos azules)
- **Decoración:** Modelos de Environment (planetas, rocas, plantas)
- **Iconos:** SVGs personalizados creados para el proyecto

## 📝 Notas de Desarrollo

- El proyecto está completamente comentado en español
- Todos los scripts siguen convenciones de nomenclatura claras
- El código está estructurado de manera modular
- Se implementaron verificaciones de existencia antes de usar recursos
- El sistema de animaciones maneja casos donde no hay animaciones disponibles

## 🐛 Solución de Problemas

**El juego no inicia:**
- Verificar que Godot 4.5 esté instalado
- Verificar que el renderizador sea Forward Plus
- Revisar la consola de errores en Godot

**Modelos no se ven:**
- Esperar a que termine la importación automática
- Verificar que los archivos .gltf estén en la carpeta correcta
- Reimportar manualmente si es necesario

**Controles no funcionan:**
- Verificar configuración de input en Project Settings
- Asegurarse de que las acciones estén configuradas correctamente

**Cámara no sigue al jugador:**
- Verificar que el nodo View tenga el target asignado correctamente
- Verificar que el script view.gd esté asignado

## 📄 Licencia

Este proyecto es de uso educativo. Los assets utilizados pueden tener sus propias licencias.

## 👤 Autor

Proyecto desarrollado como parte de un ejercicio académico en Godot 4.5.

## 🔗 Recursos Adicionales

- Documentación de Godot: https://docs.godotengine.org/
- GDScript Reference: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/
- Godot Community: https://godotengine.org/community
