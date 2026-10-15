extends Node

enum CameraState {
	LEFT,
	RIGHT,
	FORWARD,
	CAMERAS,
	HIDE
}

@warning_ignore_start("unused_signal")
signal on_change_state(oldState: CameraState, newState: CameraState)

signal camera_finished_moving

signal flashlight_triggered

signal begin_wind_up
signal end_wind_up
signal wind_attack
@warning_ignore_restore("unused_signal")

var showUIButtons := true
var forceCameraForward := false
var currentCameraState: CameraState = CameraState.FORWARD

var _winding = false
var maxWind: float = 30.0
var windGracePeriod: float = 5.0
@onready var windPerSecond: float = maxWind / 4.0
@onready var windDepletePerSecond: float = 1.0
@onready var windAmount: float = maxWind
var windGraceTimer: Timer = null

var IS_DEBUG_MODE := true

func _ready():
	on_change_state.connect(_on_change_state)
	begin_wind_up.connect(_on_begin_wind_up)
	end_wind_up.connect(_on_end_wind_up)
	windGraceTimer = Timer.new()
	add_child(windGraceTimer)
	windGraceTimer.timeout.connect(_wind_grace_timeout)

func _process(delta: float) -> void:
	if _winding:
		if windAmount <= 0:
			windGraceTimer.stop()
		windAmount = clampf(windAmount + windPerSecond * delta, 0, maxWind)
	else:
		windAmount = clampf(windAmount - windDepletePerSecond * delta, 0, maxWind)
		if windAmount == 0 and windGraceTimer.is_stopped() and not forceCameraForward:
			windGraceTimer.start(windGracePeriod)
func _on_begin_wind_up():
	_winding = true
func _on_end_wind_up():
	_winding = false
func _on_change_state(_oldState: CameraState, newState: CameraState):
	currentCameraState = newState
func _wind_grace_timeout():
	wind_attack.emit()
	windGraceTimer.stop()
