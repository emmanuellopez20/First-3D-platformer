extends Node3D

# Script de control de cámara en tercera persona

# Propiedades exportadas
@export_group("Propiedades")
@export var target: Node  # Objetivo a seguir (el jugador)

# Configuración de zoom
@export_group("Zoom")
@export var zoom_minimum = 16  # Distancia máxima de zoom
@export var zoom_maximum = 4  # Distancia mínima de zoom
@export var zoom_speed = 10  # Velocidad de zoom

# Configuración de rotación
@export_group("Rotación")
@export var rotation_speed = 120  # Velocidad de rotación de la cámara

# Variables internas
var camera_rotation: Vector3  # Rotación deseada de la cámara
var zoom = 10  # Distancia actual de zoom

@onready var camera = $Camera

func _ready():
	# Inicializar rotación de la cámara
	camera_rotation = rotation_degrees

func _physics_process(delta):
	
	# Seguir al objetivo con interpolación suave
	# Usar velocidad más rápida para seguir mejor cuando el jugador salta
	var follow_speed = 8.0 if target.position.y > self.position.y + 2.0 else 4.0
	self.position = self.position.lerp(target.position, delta * follow_speed)
	
	# Aplicar rotación con interpolación suave
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	# Aplicar zoom con interpolación suave
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
	# Procesar entrada del usuario
	handle_input(delta)

# Manejar entrada del usuario
func handle_input(delta):
	
	# Rotación de la cámara
	var input := Vector3.ZERO
	
	# Obtener input de rotación horizontal y vertical
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	# Aplicar rotación limitando la longitud del vector
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	
	# Limitar ángulo vertical para evitar rotaciones extremas
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)
	
	# Zoom
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
