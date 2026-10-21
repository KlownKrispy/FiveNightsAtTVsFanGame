extends Button

func _ready() -> void:
	EventBus.printer_errored.connect(_printer_errored)
	EventBus.printer_error_resolved.connect(_printer_resolved)
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _printer_errored(_error: Printer.PrinterError) -> void:
	visible = true
	animation_player.play("default")

func _printer_resolved() -> void:
	visible = false
	animation_player.stop()
