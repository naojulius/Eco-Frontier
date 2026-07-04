extends Node

var potions: Array[Potion] = [
	preload("res://resources/potions/hp.tres"),
	preload("res://resources/potions/mp.tres")
]

var _selected_potion_index: int = 0
var selected_potion: Potion = null

func next_potion():
	if _selected_potion_index < potions.size():
		_selected_potion_index += 1

func prev_potion():
	if _selected_potion_index > 0:
		_selected_potion_index -= 1

func _process(_delta: float) -> void:
	_selected_potion_index = clamp(_selected_potion_index, 0, potions.size())
	
	if selected_potion != potions[_selected_potion_index]:
		selected_potion = potions[_selected_potion_index]
