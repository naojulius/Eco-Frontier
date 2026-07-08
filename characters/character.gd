extends CharacterBody3D

@onready var camera_pivot: Node3D = $CameraPivot
@onready var character_node: Node3D = $CharacterNode
@onready var animation_tree: AnimationTree = $CharacterNode/CharacterMeshNode/AnimationTree


enum CharacterMovementState {
	IDLE, WALK, RUN, JUMP, ROLL
}

const WALK_SPEED = 2.0
const RUN_SPEED = 5.0
const ROLL_SPEED = 8.0 # Added: Rolls should generally feel slightly faster than running
const JUMP_VELOCITY = 8.0
const JUMP_BLEND_SPEED: float = 10.0
const ROLL_DURATION: float = 0.6 # Added: Adjust this to match your animation length

@export var rotation_speed: float = 10.0 
@export_range(-180, 180) var mesh_rotation_offset: float = 85.0

var direction: Vector3 = Vector3.ZERO
var lerped_direction: Vector3 = Vector3.ZERO
var speed: float = 0.0
var current_movement_state: CharacterMovementState = CharacterMovementState.IDLE
var input_dir: Vector2 = Vector2.ZERO
var lerp_input_dir: Vector2 = Vector2.ZERO
var jump_blend: float = 0.0
var roll_timer: float = 0.0 # Added: Tracks how long the roll has been active

func _ready() -> void:
	add_to_group("PLAYER")

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# --- ROLL STATE LOGIC ---
	if current_movement_state == CharacterMovementState.ROLL:
		roll_timer -= delta
		if roll_timer <= 0.0:
			# Roll finished, return to idle/normal state tracking
			current_movement_state = CharacterMovementState.IDLE 
		else:
			# During roll, lock direction to where you started the roll and move fast
			velocity.x = direction.x * ROLL_SPEED
			velocity.z = direction.z * ROLL_SPEED
			move_and_slide()
			return # SKIP the rest of the movement logic while rolling!

	# --- NORMAL MOVEMENT LOGIC ---
	speed = WALK_SPEED
	
	# Jump Input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get Direction inputs (Locked in air)
	#if is_on_floor():
	input_dir = Input.get_vector("D", "Q", "S", "Z")
	lerp_input_dir = lerp(lerp_input_dir, input_dir, delta * rotation_speed)
	
	direction = (camera_pivot.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	lerped_direction = lerp(lerped_direction, direction, delta * rotation_speed)
	
	if Input.is_action_pressed("SHIFT") and is_on_floor():
		speed = RUN_SPEED

	# Trigger Roll Input
	if is_on_floor() and speed == RUN_SPEED and Input.is_action_just_pressed("R"):
		current_movement_state = CharacterMovementState.ROLL
		roll_timer = ROLL_DURATION
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		# Ensure we are moving in *some* direction when rolling, default forward if stationary
		if direction == Vector3.ZERO:
			direction = -character_node.global_transform.basis.z.normalized()
	
	# Normal Movement Processing (Only runs if NOT rolling)
	if current_movement_state != CharacterMovementState.ROLL:
		if direction:
			if speed == RUN_SPEED and is_on_floor():
				animation_tree.set("parameters/Transition/transition_request", "RUN")
				current_movement_state = CharacterMovementState.RUN
			elif speed == WALK_SPEED and is_on_floor():
				animation_tree.set("parameters/Transition/transition_request", "WALK")
				current_movement_state = CharacterMovementState.WALK
			
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			
			if is_on_floor():
				character_node.look_at(global_position + lerped_direction, Vector3.UP, true)
		else:
			animation_tree.set("parameters/Transition/transition_request", "IDLE")
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
			current_movement_state = CharacterMovementState.IDLE

	camera_pivot.character_movement_state = current_movement_state
	
	# Jump Anim
	if velocity.y != 0.0:
		current_movement_state = CharacterMovementState.JUMP
		jump_blend = lerp(jump_blend, sign(velocity.y), delta * JUMP_BLEND_SPEED)
		animation_tree.set("parameters/jump_blend_space/blend_position", jump_blend)
		animation_tree.set("parameters/Transition/transition_request", "JUMP")
	else:
		animation_tree.set("parameters/jump_blend_space/blend_position", 0.0)
			
	move_and_slide()
