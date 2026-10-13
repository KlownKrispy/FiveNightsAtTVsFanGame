extends Area2D

var _hovering := false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var _pressing := false

signal pressed

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and _hovering:
		animated_sprite_2d.play("press")
		_pressing = true
	if Input.is_action_just_released("interact"):
		if _pressing and _hovering:
			pressed.emit()
		_pressing = false

func _on_mouse_entered() -> void:
	_hovering = true
	_pressing = false
	animated_sprite_2d.play("hover")

func _on_mouse_exited() -> void:
	_hovering = false
	_pressing = false
	animated_sprite_2d.play("hover")


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print(viewport, event)
