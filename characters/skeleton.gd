extends Skeleton3D

@onready var skeleton: Skeleton3D = $"."

func _ready() -> void:
	configure_weapon()
	pass

func configure_weapon():
	if WeaponManager.current_weapon:
		WeaponManager.current_weapon.configure_weapon(self)
