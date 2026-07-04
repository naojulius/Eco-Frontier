extends  Resource
class_name Potion

enum PotionType {
	# Resource Recovery
	HP,             # Crimson Red     [#C80000] - Restores Health
	MP,             # Sapphire Blue   [#0064C8] - Restores Mana / Focus Points
	STAMINA,        # Emerald Green   [#00C864] - Accelerates Stamina recovery
	REJUVENATION,   # Royal Purple    [#7B1FA2] - Restores both HP and MP simultaneously
	
	# Status Cleansers
	CURE_POISON,    # Toxic Lime      [#A4C400] - Stops toxic/poison damage over time
	CURE_BLEED,     # Clotted Wine    [#580000] - Halts hemorrhage/bleeding meters
	CURE_CURSE,     # Ghastly Ash     [#708090] - Removes death counters & max-HP reduction
	CURE_MADNESS,   # Frenzied Orange [#FF6D00] - Clears psychological frenzy meters
	
	# Offensive / Defensive Buffs
	BUFF_DAMAGE,    # Fiery Amber     [#FFAB00] - Temporarily increases raw physical power
	BUFF_CRITICAL,  # Blood Red       [#E60026] - Boosts critical strike chance/multipliers
	BUFF_DEFENSE,   # Iron Slate      [#4A5568] - Increases physical damage absorption
	RESIST_ELEMENT, # Prismatic Teal  [#00A3A3] - Increases elemental damage resistances
}
	
@export var type: PotionType = PotionType.HP:
	set(value):
		type = value
		potion_name = PotionType.keys()[value]
		_update_color()
		
@export_multiline var potion_description: String = ""
@export var potion_quantity: int = 0

var potion_color: Color = Color.from_string("#C80000", Color.BLACK)
var potion_name: String = ""

func _update_color() -> void:
	var hex: String = "#C80000"
	
	match type:
		PotionType.HP:             hex = "#C80000"
		PotionType.MP:             hex = "#0064C8"
		PotionType.STAMINA:        hex = "#00C864"
		PotionType.REJUVENATION:   hex = "#7B1FA2"
		
		PotionType.CURE_POISON:    hex = "#A4C400"
		PotionType.CURE_BLEED:     hex = "#580000"
		PotionType.CURE_CURSE:     hex = "#708090"
		PotionType.CURE_MADNESS:   hex = "#FF6D00"
		
		PotionType.BUFF_DAMAGE:    hex = "#FFAB00"
		PotionType.BUFF_CRITICAL:  hex = "#E60026"
		PotionType.BUFF_DEFENSE:   hex = "#4A5568"
		PotionType.RESIST_ELEMENT: hex = "#00A3A3"

	potion_color = Color.from_string(hex, Color.BLACK)
	# Updates the color picker box visual in your Inspector live
	notify_property_list_changed()
	
func _increase_quantity(qtt: int):
	potion_quantity += qtt
	
func _decrease_quantity(qtt: int):
	potion_quantity -= qtt
