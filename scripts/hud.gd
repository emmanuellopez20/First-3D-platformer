extends Control

# Script del HUD (Heads-Up Display) - Interfaz de usuario

# Variable para almacenar el tiempo transcurrido
var tiempo_transcurrido: float = 0.0

func _ready():
	# Inicializar el contador de tiempo
	tiempo_transcurrido = 0.0
	actualizar_tiempo()

func _process(delta):
	# Actualizar tiempo cada frame
	tiempo_transcurrido += delta
	actualizar_tiempo()

# Actualizar el contador de monedas cuando se recolecta una
func _on_coin_collected(coins):
	$Coins.text = str(coins)

# Actualizar el label del tiempo
func actualizar_tiempo():
	var minutos = int(tiempo_transcurrido / 60)
	var segundos = int(tiempo_transcurrido) % 60
	$Tiempo.text = "Tiempo: %02d:%02d" % [minutos, segundos]
