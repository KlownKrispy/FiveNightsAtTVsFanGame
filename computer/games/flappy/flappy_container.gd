extends Node2D
@onready var sub_viewport: SubViewport = $SubViewport

func _on_sprite_2d_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	var mevent: InputEventMouseButton = event
	sub_viewport.push_input(mevent)
