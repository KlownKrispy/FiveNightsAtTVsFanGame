class_name PrinterMinigame
extends Control

func _ready() -> void:
	EventBus.printer_errored.connect(_printer_errored)

@onready var status_label: Label = $StatusLabel
@onready var ink_button: Button = $InkButton
@onready var paper_button: Button = $PaperButton
@onready var food_button: Button = $FoodButton

var printerError: Printer.PrinterError = Printer.PrinterError.NONE
var _lastCamID := "BossCamera"
func handle_visibility(camID: String) -> void:
	_lastCamID = camID
	status_label.visible = (camID == "PrinterCamera")
	ink_button.visible = (camID == "PrinterCamera") and printerError == Printer.PrinterError.LOW_INK
	paper_button.visible = (camID == "StorageCamera") and printerError == Printer.PrinterError.LOW_PAPER
	food_button.visible = (camID == "BreakRoomCamera") and printerError == Printer.PrinterError.LOW_HUNGER

func _printer_errored(error: Printer.PrinterError) -> void:
	printerError = error
	match error:
		Printer.PrinterError.LOW_PAPER:
			status_label.text = "Low on paper!"
		Printer.PrinterError.LOW_INK:
			status_label.text = "Low on ink!"
			if _lastCamID == "PrinterCamera":
				handle_visibility(_lastCamID)
		Printer.PrinterError.LOW_HUNGER:
			status_label.text = "Low on food!"
		Printer.PrinterError.NONE:
			status_label.text = "All is well!"
		_:
			status_label.text = "Unknown error!"

func _resolve_error() -> void:
	EventBus.printer_error_resolved.emit()
	printerError = Printer.PrinterError.NONE
	status_label.text = "All is well!"
	handle_visibility(_lastCamID)

func _on_ink_button_pressed() -> void:
	_resolve_error()
func _on_paper_button_pressed() -> void:
	_resolve_error()
func _on_food_button_pressed() -> void:
	_resolve_error()
