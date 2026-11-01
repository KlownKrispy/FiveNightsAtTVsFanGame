extends TextureRect
@onready var error_sound: AudioStreamPlayer = $ErrorSound

func _ready() -> void:
	EventBus.printer_errored.connect(_on_printer_errored)
	EventBus.printer_error_resolved.connect(_on_printer_error_resolved)

func _on_printer_errored(_error: Printer.PrinterError):
	visible = true
	error_sound.play()

func _on_printer_error_resolved():
	visible = false
