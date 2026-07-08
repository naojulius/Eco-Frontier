extends Control
const NOTIFICATION_PANEL = preload("uid://cyk38fdmqsyuf")


@onready var notification_container: VBoxContainer = $MarginContainer/NotificationContainer

var tween: Tween
func _process(_delta: float) -> void:
	if not NotificationManager.notifications.is_empty():
		for _notification in NotificationManager.notifications:
			var panel = NOTIFICATION_PANEL.instantiate()
			notification_container.add_child(panel)
			panel.configure_panel(_notification)
			NotificationManager.notifications.erase(_notification)
			await get_tree().create_timer(0.01).timeout
	
