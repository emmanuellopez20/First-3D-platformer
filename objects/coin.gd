extends Area3D

# Script de la moneda - Maneja recolección y animaciones

# Variables de animación
var time := 0.0  # Tiempo transcurrido para animaciones
var grabbed := false  # Si la moneda ya fue recolectada

# Detectar cuando el jugador entra en el área de la moneda
func _on_body_entered(body):
	# Verificar que el cuerpo tenga el método collect_coin y que no haya sido recolectada
	if body.has_method("collect_coin") and !grabbed:
		
		# Recolectar la moneda
		body.collect_coin()
		
		# Reproducir sonido de recolección
		Audio.play("res://sounds/coin.ogg")
		
		# Ocultar el modelo de la moneda
		$PickupSphere.queue_free()
		
		# Detener partículas
		$Particles.emitting = false
		
		# Marcar como recolectada
		grabbed = true

# Animación de rotación y movimiento vertical (flotación)
func _process(delta):
	
	# Rotar la moneda alrededor del eje Y
	rotate_y(2 * delta)
	
	# Movimiento vertical usando función coseno para efecto de flotación
	position.y += (cos(time * 5) * 1) * delta
	
	# Actualizar tiempo para la animación
	time += delta
