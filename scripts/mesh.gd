@tool
extends Node3D

enum LayerType {
	CharacterLayer,
	PotionLayer,
	WeaponLayer,
}

@export var mesh_layer: LayerType = LayerType.CharacterLayer:
	set(value):
		mesh_layer = value # Crucial: Update the actual exported variable
		match value:
			LayerType.CharacterLayer:
				layer = 1
			LayerType.PotionLayer:
				layer = 2
			LayerType.WeaponLayer:
				layer = 3
		
		# If the game is running, dynamically update existing children
		if is_node_ready():
			_update_child_layers(self)

var layer: int = 1

func _ready() -> void:
	_update_child_layers(self)

# Pass the starting node as a parameter (defaults to self)
func _update_child_layers(current_node: Node) -> void:
	for node in current_node.get_children():
		if node is MeshInstance3D:
			_set_layer(node)
		
		# CRUCIAL: Always check the child's children, even if it has a mesh!
		# Characters or weapons often have nested meshes.
		if node.get_child_count() > 0:
			_update_child_layers(node)

func _set_layer(mesh: MeshInstance3D) -> void:
	mesh.layers = layer
	print(mesh.name, " set to layer mask: ", mesh.layers)
