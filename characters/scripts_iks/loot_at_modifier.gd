extends LookAtModifier3D

const MAX_DISTANCE: float = 4.0
var target_group: String = "LOOK_AT_TARGET"

# How fast the transition happens (higher = faster)
@export var lerp_speed: float = 5.0 

func _process(delta: float) -> void:
	var closest_target: Node3D = get_closest_target(target_group)
	
	if closest_target:
		# Always update the target path while it's valid
		target_node = closest_target.get_path()
		# Smoothly blend the look-at effect ON
		influence = lerp(influence, 1.0, lerp_speed * delta)
	else:
		# Smoothly blend the look-at effect OFF
		influence = lerp(influence, 0.0, lerp_speed * delta)
		
		# Optional: Clear the target path completely once influence is basically zero
		if influence < 0.01:
			influence = 0.0
			target_node = NodePath("")

func get_closest_target(group_name: String) -> Node3D:
	var targets = get_tree().get_nodes_in_group(group_name)
	var closest_node: Node3D = null
	var min_distance: float = INF 
	
	var max_distance_squared: float = MAX_DISTANCE * MAX_DISTANCE
	
	for target in targets:
		if target is Node3D and target != self:
			var distance = global_position.distance_squared_to(target.global_position)
			
			if distance < min_distance and distance <= max_distance_squared:
				min_distance = distance
				closest_node = target
				
	return closest_node
