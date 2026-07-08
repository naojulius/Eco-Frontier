extends Node

var notifications : Array[String] = []

func add_notification(text: String) -> void:
	if text:
		notifications.append(text)
