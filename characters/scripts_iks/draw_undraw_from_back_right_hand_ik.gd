extends TwoBoneIK3D

const MAX_PATH_PROGRESS: float = 1.0
const MIN_PATH_PROGRESS: float = 0.0
const PATH_PROGRESS_WAIT_TIME: float = 0.25

@onready var target_path_folow: PathFollow3D = $TargetPath/TargetPathFolow
@onready var pole_path_follow: PathFollow3D = $PolePath/PolePathFollow

var sheathed_bone_name: String = ""
var drawed_bone_name: String = ""

enum WeaponState {
	SHEATHED, # L'épée est rangée dans le dos
	SWITCHING, # Le bras est en mouvement (état intermédiaire)
	DRAWN     # L'épée est sortie, en main
}

var current_weapon_state: WeaponState = WeaponState.SHEATHED

var skeleton_parent: Skeleton3D = null
var sheathed_bone_attachment: BoneAttachment3D
var drawn_bone_attachment: BoneAttachment3D
var tween: Tween

# Permet de savoir si on est en train de dégainer (true) ou de ranger (false)
var is_drawing: bool = true

func _ready() -> void:
	skeleton_parent = get_parent()
	sheathed_bone_attachment = skeleton_parent.get_node_or_null(sheathed_bone_name)
	drawn_bone_attachment = skeleton_parent.get_node_or_null(drawed_bone_name)
	influence = 0.0
	
	update_weapon_visibility()
	
	# La main commence devant, en position neutre
	target_path_folow.progress_ratio = MIN_PATH_PROGRESS
	pole_path_follow.progress_ratio = MIN_PATH_PROGRESS

func _process(_delta: float) -> void:
	# Clic droit pour ranger l'épée si elle est déjà sortie
	if Input.is_action_just_pressed("RIGHT_MOUSE") and current_weapon_state == WeaponState.DRAWN:
		sheathe_weapon()
	
	if Input.is_action_just_pressed("LEFT_MOUSE") and current_weapon_state == WeaponState.SHEATHED:
		draw_weapon()

func reset_tween() -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()

## Déclenche l'action de dégainer
func draw_weapon() -> void:
	if current_weapon_state != WeaponState.SHEATHED: return
	current_weapon_state = WeaponState.SWITCHING
	is_drawing = true
	move_hand_to_back()

## Déclenche l'action de ranger/rengainer
func sheathe_weapon() -> void:
	if current_weapon_state != WeaponState.DRAWN: return
	current_weapon_state = WeaponState.SWITCHING
	is_drawing = false
	move_hand_to_back()
# --- Mouvements du Tween ---

# Envoie la main vers le dos (ratio -> 1.0)
func move_hand_to_back() -> void:
	reset_tween()
	tween.tween_property(self, "influence", 1.0, 0.05) 
	
	tween.parallel().tween_property(target_path_folow, "progress_ratio", MAX_PATH_PROGRESS, PATH_PROGRESS_WAIT_TIME)
	tween.parallel().tween_property(pole_path_follow, "progress_ratio", MAX_PATH_PROGRESS, PATH_PROGRESS_WAIT_TIME)
	tween.tween_callback(_on_back_reached)

# Ramène la main vers l'avant (ratio -> 0.0)
func move_hand_to_front() -> void:
	reset_tween()
	tween.tween_property(target_path_folow, "progress_ratio", MIN_PATH_PROGRESS, PATH_PROGRESS_WAIT_TIME)
	tween.parallel().tween_property(pole_path_follow, "progress_ratio", MIN_PATH_PROGRESS, PATH_PROGRESS_WAIT_TIME)
	tween.tween_callback(_on_front_reached)


# --- Callbacks de fin d'animation ---

# Étape A : La main est arrivée dans le dos
func _on_back_reached() -> void:
	if is_drawing:
		current_weapon_state = WeaponState.DRAWN
		update_weapon_visibility()
		move_hand_to_front()
	else:
		current_weapon_state = WeaponState.SHEATHED
		update_weapon_visibility()
		move_hand_to_front()

# Étape B : La main est revenue devant
func _on_front_reached() -> void:
	if current_weapon_state == WeaponState.SHEATHED:
		var clear_tween = create_tween()
		clear_tween.tween_property(self, "influence", 0.0, 0.1)
	
	print("Movement complete. Weapon state: ", WeaponState.keys()[current_weapon_state])


## Gestion de l'affichage de l'arme (Show / Hide)
func update_weapon_visibility() -> void:
	if !sheathed_bone_attachment or !drawn_bone_attachment: return
	
	var sheathed_weapon = sheathed_bone_attachment.get_node_or_null("Weapon")
	var drawn_weapon = drawn_bone_attachment.get_node_or_null("Weapon")
	
	if !sheathed_weapon or !drawn_weapon: return

	match current_weapon_state:
		WeaponState.SHEATHED:
			drawn_weapon.hide()
			sheathed_weapon.show()
		WeaponState.DRAWN:
			drawn_weapon.show()
			sheathed_weapon.hide()
