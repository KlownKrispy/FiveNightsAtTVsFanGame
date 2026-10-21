extends Control

const messages: Array[String] = [
	"There is no horse",
	"Quit horsing around",
]
@onready var label: Label = $Label

func _ready() -> void:
	if EventBus.IS_DEBUG_MODE:
		animated_sprite_2d.visible = true
		label.visible = false
	else:
		label.text = messages.pick_random()

var time: float = 0.0
func _process(delta: float) -> void:
	if EventBus.IS_DEBUG_MODE:
		return
	time += delta
	if time >= 1.0 / 60.0:
		if not EventBus.IS_DEBUG_MODE:
			visible = false

func _on_horse_exit_button_pressed() -> void:
	visible = false

func _on_animated_sprite_2d_animation_finished() -> void:
	visible = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func _on_visibility_changed() -> void:
	time = 0
	if visible and EventBus.IS_DEBUG_MODE:
		animated_sprite_2d.play()
