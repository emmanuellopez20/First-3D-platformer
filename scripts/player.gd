extends CharacterBody3D

# Señal emitida cuando se recolecta una moneda
signal coin_collected

# Componentes exportados
@export_subgroup("Componentes")
@export var view: Node3D

# Propiedades del jugador
@export_subgroup("Propiedades")
@export var movement_speed = 250  # Velocidad de movimiento
@export var jump_strength = 12  # Fuerza del salto (aumentada para saltos más altos)

# Variables de movimiento
var movement_velocity: Vector3  # Velocidad de movimiento calculada
var rotation_direction: float  # Dirección de rotación
var gravity = 0  # Gravedad aplicada

# Variables de estado
var previously_floored = false  # Si estaba en el suelo en el frame anterior
var jump_single = true  # Permite salto simple
var jump_double = true  # Permite doble salto
var coins = 0  # Contador de monedas recolectadas

# Referencias a nodos hijos
@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer

# Función principal de física - se ejecuta cada frame
func _physics_process(delta):
	
	# Procesar controles, gravedad y efectos
	handle_controls(delta)
	handle_gravity(delta)
	handle_effects(delta)

	# Aplicar movimiento
	var applied_velocity: Vector3
	
	# Interpolar suavemente la velocidad de movimiento
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity  # Aplicar gravedad en el eje Y

	velocity = applied_velocity
	move_and_slide()  # Mover el personaje y detectar colisiones

	# Rotación del personaje hacia la dirección de movimiento
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()

	# Interpolar suavemente la rotación
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)

	# Sistema de respawn si cae demasiado
	if position.y < -10:
		get_tree().reload_current_scene()

	# Animación de escala (efecto visual al saltar y aterrizar)
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)

	# Efecto visual al aterrizar
	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)  # Aplastar ligeramente
		Audio.play("res://sounds/land.ogg")  # Sonido de aterrizaje

	previously_floored = is_on_floor()

# Manejar animaciones y efectos visuales
func handle_effects(delta):
	
	# Desactivar efectos por defecto
	particles_trail.emitting = false
	sound_footsteps.stream_paused = true

	# Verificar si el AnimationPlayer tiene animaciones disponibles
	if not animation or not animation.has_animation("idle"):
		# Si no hay animaciones, solo manejar efectos de sonido y partículas
		if is_on_floor():
			var horizontal_velocity = Vector2(velocity.x, velocity.z)
			var speed_factor = horizontal_velocity.length() / movement_speed / delta
			
			if speed_factor > 0.3:
				sound_footsteps.stream_paused = false
				sound_footsteps.pitch_scale = speed_factor
			
			if speed_factor > 0.75:
				particles_trail.emitting = true
		return

	if is_on_floor():
		# Calcular velocidad horizontal para determinar animación
		var horizontal_velocity = Vector2(velocity.x, velocity.z)
		var speed_factor = horizontal_velocity.length() / movement_speed / delta
		
		if speed_factor > 0.05:
			# Reproducir animación de caminar si existe y no está activa
			if animation.has_animation("walk") and animation.current_animation != "walk":
				animation.play("walk", 0.1)

			# Activar sonido de pasos si se mueve lo suficientemente rápido
			if speed_factor > 0.3:
				sound_footsteps.stream_paused = false
				sound_footsteps.pitch_scale = speed_factor  # Ajustar pitch según velocidad

			# Activar partículas de polvo si corre
			if speed_factor > 0.75:
				particles_trail.emitting = true

		elif animation.has_animation("idle") and animation.current_animation != "idle":
			# Reproducir animación de idle si está quieto
			animation.play("idle", 0.1)
			
		# Ajustar velocidad de animación según velocidad de movimiento
		if animation.has_animation("walk") and animation.current_animation == "walk":
			animation.speed_scale = speed_factor
		elif animation.has_animation("idle"):
			animation.speed_scale = 1.0
			
	elif animation.has_animation("jump") and animation.current_animation != "jump":
		# Reproducir animación de salto si está en el aire
		animation.play("jump", 0.1)

# Manejar entrada de controles y movimiento
func handle_controls(delta):
	
	# Obtener input del jugador (8 direcciones)
	var input := Vector3.ZERO

	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	# Rotar el input según la rotación de la cámara
	input = input.rotated(Vector3.UP, view.rotation.y)

	# Normalizar si el vector es mayor a 1 (movimiento diagonal)
	if input.length() > 1:
		input = input.normalized()

	# Calcular velocidad de movimiento
	movement_velocity = input * movement_speed * delta

	# Manejar salto
	if Input.is_action_just_pressed("jump"):
		# Permitir salto si tiene saltos disponibles
		if jump_single or jump_double:
			jump()

# Manejar gravedad
func handle_gravity(delta):
	
	# Aumentar gravedad constantemente
	gravity += 25 * delta

	# Resetear gravedad y permitir salto si está en el suelo
	if gravity > 0 and is_on_floor():
		jump_single = true
		gravity = 0

# Función de salto
func jump():
	
	# Reproducir sonido de salto
	Audio.play("res://sounds/jump.ogg")

	# Aplicar fuerza de salto (negativa porque Y apunta hacia arriba)
	gravity = -jump_strength

	# Efecto visual: estirar el modelo verticalmente
	model.scale = Vector3(0.5, 1.5, 0.5)

	# Gestionar saltos disponibles
	if jump_single:
		jump_single = false
		jump_double = true  # Permitir doble salto
	else:
		jump_double = false  # Agotar saltos

# Recolectar moneda
func collect_coin():
	
	coins += 1
	
	# Emitir señal para actualizar el HUD
	coin_collected.emit(coins)
