extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rich_text_label: RichTextLabel = $PanelContainer/RichTextLabel

func configure_ui(resource: Loot):
	rich_text_label.text = str(resource.get_command_text())
	
func play_show() -> void:
	if not animation_player.is_playing():
		animation_player.play("show")

func play_hide() -> void:
	if not animation_player.is_playing():
		animation_player.play("hide")
