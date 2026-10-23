extends Control


var _winding = false
var maxWind: float:
	get: return Night.get_current_night().computerMaxWindSeconds
var windGracePeriod: float:
	get: return Night.get_current_night().computerWindGracePeriod
var windPerSecond: float:
	get: return Night.get_current_night().computerWindPerSecond

@onready var windAmount: float = maxWind
@onready var wind_grace_timer: Timer = $WindGraceTimer
@onready var wind_progress: TextureProgressBar = $WindButton/WindProgress

func _ready() -> void:
	Night.night_changed.connect(_night_changed)
	_night_changed()

func _process(delta: float) -> void:
	var oldWind := windAmount
	if _winding:
		if windAmount <= 0:
			wind_grace_timer.stop()
		windAmount = clampf(windAmount + windPerSecond * delta, 0, maxWind)
	else:
		windAmount = clampf(windAmount - delta, 0, maxWind)
		if windAmount == 0 and wind_grace_timer.is_stopped() and not EventBus.forceCameraForward:
			wind_grace_timer.start(windGracePeriod)
	wind_progress.value = windAmount
	if oldWind >= 0.25 * maxWind and windAmount < 0.25 * maxWind:
		EventBus.computer_low.emit()
	if oldWind > 0 and windAmount <= 0:
		EventBus.computer_empty.emit()
	if oldWind < 0.25 * maxWind and windAmount >= 0.25 * maxWind:
		EventBus.computer_error_silence.emit()

func _night_changed():
	windAmount = Night.get_current_night().computerInitialWindAmount
	wind_progress.max_value = maxWind

func _on_wind_button_button_up() -> void:
	_winding = false
func _on_wind_button_button_down() -> void:
	_winding = true

func _on_wind_grace_timer_timeout() -> void:
	EventBus.wind_attack.emit()
