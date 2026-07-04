extends Control

@onready var rich_text: RichTextLabel = $RichText

# Seuils pour les FPS
@export var fps_good: int = 50
@export var fps_warning: int = 30

# Seuils pour la Mémoire (en Mo)
@export var mem_warning: float = 400.0
@export var mem_critical: float = 800.0

# Couleurs en code Hexadécimal
const COLOR_GOOD = "#2ecc71"     # Vert
const COLOR_WARN = "#e67e22"     # Orange
const COLOR_CRIT = "#e74c3c"     # Rouge

func _process(_delta: float) -> void:
	# 1. Récupération des données
	var fps: float = Engine.get_frames_per_second()
	
	# Convertit les octets retournés par Godot en Mégaoctets (Mo)
	var mem_bytes: float = OS.get_static_memory_usage()
	var mem_mb: float = mem_bytes / 1024.0 / 1024.0
	
	# Temps de process en millisecondes
	var process_time: float = Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0

	# 2. Détermination des couleurs
	var fps_color: String = _get_fps_color(fps)
	var mem_color: String = _get_mem_color(mem_mb)
	var proc_color: String = _get_proc_color(process_time)

	# 3. Mise à jour du texte avec le BBCode
	rich_text.text = (
		"FPS : [color=" + fps_color + "]" + str(fps) + "[/color]\n" +
		"RAM : [color=" + mem_color + "]" + "%.2f" % mem_mb + " MB[/color]\n" +
		"Frame Time : [color=" + proc_color + "]" + "%.2f" % process_time + " ms[/color]"
	)

# --- Fonctions utilitaires pour la logique des couleurs ---

func _get_fps_color(current_fps: float) -> String:
	if current_fps >= fps_good:
		return COLOR_GOOD
	elif current_fps >= fps_warning:
		return COLOR_WARN
	else:
		return COLOR_CRIT

func _get_mem_color(current_mem: float) -> String:
	if current_mem < mem_warning:
		return COLOR_GOOD
	elif current_mem < mem_critical:
		return COLOR_WARN
	else:
		return COLOR_CRIT

func _get_proc_color(current_time: float) -> String:
	# Idéalement, une frame à 60 FPS prend 16.67ms. 
	# Si le process prend plus de 12ms à lui seul, on passe en warning.
	if current_time < 8.0:
		return COLOR_GOOD
	elif current_time < 12.0:
		return COLOR_WARN
	else:
		return COLOR_CRIT
