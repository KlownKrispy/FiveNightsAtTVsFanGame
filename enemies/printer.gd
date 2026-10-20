class_name Printer
extends AnimatedSprite3D
@onready var error_timer: Timer = $ErrorTimer

var _errored := false
var _workload: int = 0

enum PrinterError {
	NONE,
	LOW_PAPER,
	LOW_INK,
	LOW_HUNGER,
}

func _ready() -> void:
	Night.night_changed.connect(_night_changed)
	_night_changed()
	_begin_error_clock()
	EventBus.printer_error_resolved.connect(_on_error_resolved)
	Night.minute_passed.connect(_minute_passed)

func _night_changed() -> void:
	_workload = Night.get_current_night().printerWorkload

func _minute_passed() -> void:
	if _errored:
		return
	_workload -= 1
	if _workload == 0:
		Night.end_night()

func _begin_error_clock():
	_errored = false
	var errorTime := randf_range(
		Night.get_current_night().printerMinimumErrorTime,
		Night.get_current_night().printerMaximumErrorTime
	)
	error_timer.start(errorTime)

func _on_error_resolved():
	_begin_error_clock()

func _on_error_timer_timeout() -> void:
	var error: PrinterError = (
		PrinterError.values()
			.filter(_only_real_errors)
			.pick_random()
	)
	EventBus.printer_errored.emit(error)
	_errored = true

func _only_real_errors(e: Printer.PrinterError) -> bool:
	return e != PrinterError.NONE
