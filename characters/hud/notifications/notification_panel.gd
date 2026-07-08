extends Panel

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.connect("timeout", on_show_timeout)
	animation_player.connect("animation_finished", on_animation_finished)

func configure_panel(text: String):
	rich_text_label.text = str(text)
	pass
	
func on_show_timeout():
	if not animation_player.is_playing():
		animation_player.play("hide")
	
func on_animation_finished(anim_name: String):
	if anim_name.to_lower().begins_with("init"):
		timer.start()
			
	if anim_name.to_lower().begins_with("hide"):
		queue_free()
