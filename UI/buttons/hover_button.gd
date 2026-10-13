class_name HoverButton
extends TextureRect

signal button_up
signal button_down
signal pressed

var action_mode: BaseButton.ActionMode = BaseButton.ActionMode.ACTION_MODE_BUTTON_PRESS

func _on_mouse_entered() -> void:
	button_down.emit()
	if action_mode == BaseButton.ActionMode.ACTION_MODE_BUTTON_PRESS:
		pressed.emit()
func _on_mouse_exited() -> void:
	button_up.emit()
	if action_mode == BaseButton.ActionMode.ACTION_MODE_BUTTON_RELEASE:
		pressed.emit()
