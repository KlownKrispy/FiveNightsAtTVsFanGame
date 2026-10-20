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

signal printer_errored(error: Printer.PrinterError)
signal printer_error_resolved
@warning_ignore_restore("unused_signal")

var showUIButtons := true
var forceCameraForward := false
var currentCameraState: CameraState = CameraState.FORWARD

var IS_DEBUG_MODE := true

func _ready():
	on_change_state.connect(_on_change_state)

func _on_change_state(_oldState: CameraState, newState: CameraState):
	currentCameraState = newState
