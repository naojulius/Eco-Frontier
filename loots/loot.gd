extends Resource
class_name Loot

@export_group("PACKED_SCENES")
@export var loot_ui: PackedScene

@export_group("INFORMATIONS")
@export var command_text: String
@export var notification_text: String

@export_group("ICONS")
@export_file_path() var command_icon: String
@export_file_path() var notification_icon: String

@export_group("ICON_SIZE")
@export var command_icon_size: Vector2 = Vector2(30, 30)
@export var notification_icon_size: Vector2 = Vector2(30, 30)

func get_command_text() -> String:
	var img_tag: String = "[img={%d}x{%d}]%s[/img]" % [command_icon_size.x, command_icon_size.y, command_icon]
	return command_text.replace("_ICON_", img_tag)

func get_notification_text() -> String:
	var img_tag: String = "[img={%d}x{%d}]%s[/img]" % [notification_icon_size.x, notification_icon_size.y, notification_icon]
	return notification_text.replace("_ICON_", img_tag)
