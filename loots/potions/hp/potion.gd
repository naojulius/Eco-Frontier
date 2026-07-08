extends "res://loots/loot_node.gd"

func _ready() -> void:
	super()
	add_to_group("POTION")

func do_command() -> void:
	super()
	#add notification
	NotificationManager.add_notification(
		str(resource.get_notification_text())
	)
	
	#remove the node in tree
	queue_free()
	
	
