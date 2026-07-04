@tool
extends Panel

var resource: Potion
var is_empty: bool = true

@export var is_active: bool = false
@export var id: int = 0

func _ready() -> void:
	name = str("Potion_Panel_", id)
	if resource:
		pass
	

func _process(_delta: float) -> void:
	#scale = Vector2(1.0, 1.0) if is_active else Vector2(0.7, 0.7)
	pass
