extends Node

# Sistema de audio - Permite reproducir múltiples sonidos simultáneamente
# Utiliza un pool de reproductores de audio para evitar conflictos

var num_players = 12  # Número de reproductores de audio en el pool
var bus = "master"  # Bus de audio a utilizar

var available = []  # Lista de reproductores disponibles
var queue = []  # Cola de sonidos a reproducir

func _ready():
	# Crear pool de reproductores de audio
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		
		available.append(p)
		
		# Configurar volumen y conectar señal
		p.volume_db = -10
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus

# Cuando un sonido termina, devolver el reproductor al pool
func _on_stream_finished(stream): 
	available.append(stream)

# Agregar sonido a la cola de reproducción
func play(sound_path): 
	queue.append(sound_path)

# Procesar cola de sonidos
func _process(_delta):
	# Si hay sonidos en cola y reproductores disponibles
	if not queue.is_empty() and not available.is_empty():
		
		# Cargar y reproducir el siguiente sonido
		available[0].stream = load(queue.pop_front())
		available[0].play()
		
		# Variar ligeramente el pitch para evitar repetición monótona
		available[0].pitch_scale = randf_range(0.9, 1.1)
		
		# Remover el reproductor de la lista de disponibles
		available.pop_front()
