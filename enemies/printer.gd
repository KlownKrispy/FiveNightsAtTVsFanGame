class_name Printer
extends AnimatedSprite3D
@onready var error_timer: Timer = $ErrorTimer

var _countingOvertime := false
var _partialOvertime: float = 0.0

enum PrinterError {
	LOW_PAPER,
	LOW_INK,
	LOW_HUNGER,
}

func _ready() -> void:
	_begin_error_clock()
	EventBus.printer_error_resolved.connect(_on_error_resolved)

func _process(delta: float) -> void:
	if not _countingOvertime:
		return
	if Night.overtime >= Night.get_current_night().maxOvertime:
		Night.overtime = Night.get_current_night().maxOvertime
		_countingOvertime = false
		return
	_partialOvertime += delta
	var overtimeConversion := float(Night.get_current_night().printerIdleConversion)
	while _partialOvertime >= overtimeConversion:
		_partialOvertime -= overtimeConversion
		Night.overtime += 1

func _begin_error_clock():
	_countingOvertime = false
	var errorTime := randf_range(
		Night.get_current_night().printerMinimumErrorTime,
		Night.get_current_night().printerMaximumErrorTime
	)
	error_timer.start(errorTime)

func _on_error_resolved():
	_begin_error_clock()

@onready var overtime_begin_timer: Timer = $OvertimeBeginTimer
func _on_error_timer_timeout() -> void:
	var error: PrinterError = PrinterError.values().pick_random()
	EventBus.printer_errored.emit(error)
	var overtimeGrace := Night.get_current_night().printerMinimumIdleForOvertime
	if overtimeGrace == 0:
		_countingOvertime = true
	else:
		overtime_begin_timer.start(overtimeGrace)

func _on_overtime_begin_timer_timeout() -> void:
	_countingOvertime = true
