extends Node3D
@export var resource: Loot

@onready var loot_area: Area3D = $LootArea
var is_pickable: bool = false
var ui: Control

func _ready() -> void:
	add_to_group("LOOTS")
	add_to_group("LOOK_AT_TARGET")
	
	#configure signals
	loot_area.connect("body_entered", _on_body_entered)
	loot_area.connect("body_exited", _on_body_exited)
	
	#configure UI 
	ui = resource.loot_ui.instantiate()
	add_child(ui)
	ui.configure_ui(resource)
	
func _on_body_entered(body):
	if body is CharacterBody3D and body.is_in_group("PLAYER"):
		is_pickable = true
		ui.play_show()

func _on_body_exited(body):
	if body is CharacterBody3D and body.is_in_group("PLAYER"):
		is_pickable = false
		ui.play_hide()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("E") and is_pickable:
		do_command()

func do_command() -> void:
	pass
