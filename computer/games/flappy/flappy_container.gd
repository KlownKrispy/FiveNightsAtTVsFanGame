extends Node2D
@onready var sub_viewport: SubViewport = $SubViewport

func _on_sprite_2d_gui_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	var mevent: InputEventMouseButton = event
	if mevent.button_index != MOUSE_BUTTON_LEFT:
		return
	sub_viewport.push_input(mevent)

@onready var pause_label: Label = $PauseLabel
@onready var pause_timer: Timer = $PauseTimer
var pauseTime: int = 3
var pauseTimeCurrent: int = 3
func unpause():
	pauseTimeCurrent = pauseTime
	var remainingSeconds := pauseTimeCurrent
	pause_label.text = "Starting in %d..." % remainingSeconds
	pause_label.visible = true
	pause_timer.start(1.0)
func _unpause() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	pause_label.visible = false
func _on_pause_timer_timeout() -> void:
	pauseTimeCurrent -= 1
	var remainingSeconds := pauseTimeCurrent
	pause_label.text = "Starting in %d..." % remainingSeconds
	if pauseTimeCurrent <= 0:
		_unpause()
	else:
		pause_timer.start(1.0)
