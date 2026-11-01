extends TextureRect

func _ready() -> void:
	EventBus.printer_errored.connect(_on_printer_errored)
	EventBus.printer_error_resolved.connect(_on_printer_error_resolved)

func _on_printer_errored(_error: Printer.PrinterError):
	visible = true

func _on_printer_error_resolved():
	visible = false
