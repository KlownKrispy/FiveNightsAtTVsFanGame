extends Node

var _debugNight: NightConfig = preload("uid://jh2ryc63wusi")
var _currentNight := _debugNight

var _minuteTimer: Timer = null

var _currentTime: int = 0

var _secondsPerMinute := 1

func get_current_time() -> int:
	return _currentTime

## Returns the clock hour (in 24 hour format!)
func get_clock_hour() -> int:
	@warning_ignore("integer_division")
	var hour: int = _currentTime / 60
	if _currentTime < 0:
		# Floor without float math by subtracting 59 before division
		@warning_ignore("integer_division")
		hour = (_currentTime - 59) / 60
	while hour < 0:
		hour += 24
	return hour

## Returns the clock minute (0-59)
func get_clock_minute() -> int:
	return posmod(_currentTime, 60)

func _ready() -> void:
	_minuteTimer = Timer.new()
	add_child(_minuteTimer)
	_minuteTimer.timeout.connect(_on_minute_timer_timeout)
	start_night()

func start_night() -> void:
	_currentTime = get_current_night().nightTimeStart
	_minuteTimer.start(_secondsPerMinute)
	night_changed.emit()

func get_current_night() -> NightConfig:
	return _currentNight

func _on_minute_timer_timeout() -> void:
	minute_passed.emit()
	_currentTime += 1
	if (_currentTime % 60) == 0:
		hour_passed.emit()

signal night_changed
signal minute_passed
signal hour_passed
