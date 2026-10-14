class_name ComputerScreen
extends Node2D

func _ready() -> void:
	UIEvent.on_change_state.connect(_on_camera_change_state)
	UIEvent.camera_finished_moving.connect(_on_camera_finished_moving)

func show_computer():
	pass

func hide_computer():
	UIEvent.on_change_state.emit(UIEvent.CameraState.CAMERAS, UIEvent.CameraState.FORWARD)
	UIEvent.showUIButtons = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_camera_finished_moving() -> void:
	pass
@onready var ui: Control = $UI

func _on_camera_change_state(_oldState: UIEvent.CameraState, newState: UIEvent.CameraState) -> void:
	pass
@onready var cursor: Sprite2D = $Cursor
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cursor.position += event.relative
		cursor.position.x = clampf(cursor.position.x, 0, 686)
		cursor.position.y = clampf(cursor.position.y, 0, 511)

func _on_power_button_pressed() -> void:
	hide_computer()
