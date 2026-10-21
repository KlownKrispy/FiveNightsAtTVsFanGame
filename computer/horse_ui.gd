extends Control

func _on_horse_exit_button_pressed() -> void:
	visible = false


func _on_animated_sprite_2d_animation_finished() -> void:
	visible = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func _on_visibility_changed() -> void:
	if visible:
		animated_sprite_2d.play()
