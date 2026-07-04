extends Node3D

@export var character_node: Node3D
@onready var camera_pivot: Node3D = $"."
@onready var spring_arm: SpringArm3D = $CameraNode/SpringArm
@onready var camera_node: Node3D = $CameraNode

@export var mouse_sensitivity: float = 0.003
@export var min_pitch: float = -50.0 # En degrés (limite vers le bas)
@export var max_pitch: float = 50.0  # En degrés (limite vers le haut)

const IDLE_SPRING_LENGTH: float = 2.5
const WALK_SPRING_LENGTH: float = 3.0
const RUN_SPRING_LENGTH: float = 3.5
const SPRING_LENGTH_SPEED: float = 3.0
const ROLL_SPRING_LENGTH: float = 4.5

var character_movement_state: int = 0
var can_rotate_cam: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character_node = get_parent().get_node("CharacterNode")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# 1. Rotation horizontale (Yaw) appliquée au pivot global
		camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		
		# 2. Rotation verticale (Pitch) appliquée au SpringArm3D
		spring_arm.rotate_x(event.relative.y * mouse_sensitivity)
		
		# 3. Limitation de l'inclinaison verticale pour éviter que la caméra ne se retourne
		spring_arm.rotation.x = clamp(
			spring_arm.rotation.x, 
			deg_to_rad(min_pitch), 
			deg_to_rad(max_pitch)
		)

		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match  character_movement_state:
		0: #IDLE
			spring_arm.spring_length = lerp(spring_arm.spring_length, IDLE_SPRING_LENGTH, delta * SPRING_LENGTH_SPEED)
			camera_node.position.y = 0.531
			can_rotate_cam = true
		1: #WALK
			spring_arm.spring_length = lerp(spring_arm.spring_length, WALK_SPRING_LENGTH, delta * SPRING_LENGTH_SPEED)
			camera_node.position.y = 0.531
			can_rotate_cam = true
		2: #RUN
			spring_arm.spring_length = lerp(spring_arm.spring_length, RUN_SPRING_LENGTH, delta * SPRING_LENGTH_SPEED)
			camera_node.position.y = 0.531
			can_rotate_cam = true
		3: #JUMP
			pass
		4:# ROLL
			spring_arm.spring_length = lerp(spring_arm.spring_length, ROLL_SPRING_LENGTH, delta * 10.0)
			camera_node.position.y = 0.531
			can_rotate_cam = false
			pass
		_:
			spring_arm.spring_length = lerp(spring_arm.spring_length, IDLE_SPRING_LENGTH, delta * SPRING_LENGTH_SPEED)
			camera_node.position.y = 0.531
			can_rotate_cam = true
	pass
