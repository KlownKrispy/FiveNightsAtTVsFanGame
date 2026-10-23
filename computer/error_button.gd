extends TextureRect

func _ready() -> void:
	EventBus.computer_error_silence.connect(_computer_error_silence)
	EventBus.computer_low.connect(_computer_low)
	EventBus.computer_empty.connect(_computer_empty)
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _computer_error_silence() -> void:
	visible = false
	animation_player.stop()

func _computer_low() -> void:
	visible = true
	animation_player.play("warning")

func _computer_empty() -> void:
	visible = true
	animation_player.play("urgent")
