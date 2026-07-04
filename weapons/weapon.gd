extends Resource
class_name Weapon
enum Weapontype {
	# Daggers & Light Blades (Fast, high critical/backstab, low stagger)
	DAGGER,
	
	# Swords (Versatile, balanced speed and damage)
	SWORD,          # Straight swords / Arming swords
	LONG_SWORD,     # Greatswords (Two-handed variants)
	COLOSSAL_SWORD, # Ultra Greatswords (Slow, massive poise damage)
	CURVED_SWORD,   # Fast, slashing, often Dexterity-focused
	
	# Axes & Hammers (High stagger, strength-focused)
	AXE,
	GREAT_AXE,
	HAMMER,         # Maces / Clubs
	GREAT_HAMMER,   # Greataxes / Colossal weapons
	
	# Polearms & Whips (Excellent spacing and range)
	SPEAR,
	HALBERD,
	WHIP,
	SCYTHE,         # Reaper weapons (often deal bleed/frost)
	
	# Ranged Weapons
	BOW,
	CROSS_BOW,
	GREAT_BOW,      # Heavy, anchors you to the ground to fire
	
	# Magic Catalysts
	STAFF,          # Sorceries / Intelligence
	SACRED_SEAL     # Incantations / Miracles / Faith
}

@export_group("INFOMATIONS")
@export var weapon_name: String
@export var weapon_type: Weapontype

@export_group("PACKED SCENES")
@export var _drawed: PackedScene
@export var _sheathed: PackedScene
@export var _ik: PackedScene

var skeleton: Skeleton3D

func configure_weapon(_skeleton: Skeleton3D):
	if _skeleton:
		var drawed: BoneAttachment3D = _drawed.instantiate()
		var sheathed: BoneAttachment3D = _sheathed.instantiate()
		var ik: TwoBoneIK3D = _ik.instantiate()
		
		ik.drawed_bone_name = drawed.name
		ik.sheathed_bone_name = sheathed.name
		
		_skeleton.add_child(sheathed)
		_skeleton.add_child(drawed)
		_skeleton.add_child(ik)
	
