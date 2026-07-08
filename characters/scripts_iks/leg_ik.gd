extends TwoBoneIK3D
@onready var leg_ik_right_marker: Marker3D = $LegIk_Right_Marker
@onready var leg_ik_right_raycast: RayCast3D = $LegIk_Right_Raycast

func _process(_delta: float) -> void:
	if leg_ik_right_raycast.is_colliding():
		var collision_point = leg_ik_right_raycast.get_collision_point()
		leg_ik_right_marker.global_position.y = collision_point.y + 0.05
