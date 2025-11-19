extends Node3D

# Script principal de la escena - Configuración del renderizador

func _ready() -> void:
	# Ajustar iluminación si se usa el renderizador de compatibilidad
	# Esto compensa las diferencias entre Forward+ y Compatibility
	if RenderingServer.get_current_rendering_method() == "gl_compatibility":
		# Reducir brillo del sol y opacidad de sombras
		$Sun.light_energy = 0.24
		$Sun.shadow_opacity = 0.85
		
		# Reducir brillo del fondo
		$Environment.environment.background_energy_multiplier = 0.25
