class_name ComputerScreen
extends Node2D

func show_computer():
	pass

func hide_computer():
	UIEvent.on_change_state.emit(UIEvent.CameraState.CAMERAS, UIEvent.CameraState.FORWARD)
	UIEvent.showUIButtons = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

@onready var ui: Control = $UI
@onready var cursor: Sprite2D = $Cursor
@onready var cameras_ui: Control = $CamerasUI

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cursor.position += event.relative
		cursor.position.x = clampf(cursor.position.x, 0, 686)
		cursor.position.y = clampf(cursor.position.y, 0, 511)

func _on_power_button_pressed() -> void:
	hide_computer()

func _on_cameras_tab_pressed() -> void:
	cameras_ui.visible = not cameras_ui.visible

func _on_cameras_exit_button_pressed() -> void:
	cameras_ui.visible = false
