extends Node2D

var _makeVisibleWhenAnimFinished := false

func _ready() -> void:
	UIEvent.on_change_state.connect(_on_camera_change_state)
	UIEvent.camera_finished_moving.connect(_on_camera_finished_moving)

func show_computer():
	pass

func hide_computer():
	pass

func _on_camera_finished_moving() -> void:
	if _makeVisibleWhenAnimFinished:
		show_computer()
		_makeVisibleWhenAnimFinished = false
	else:
		hide_computer()

func _on_camera_change_state(_oldState: UIEvent.CameraState, newState: UIEvent.CameraState) -> void:
	if newState == UIEvent.CameraState.CAMERAS:
		_makeVisibleWhenAnimFinished = true
	else:
		_makeVisibleWhenAnimFinished = false
