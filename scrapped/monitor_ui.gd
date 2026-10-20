extends Control

var _makeVisibleWhenAnimFinished := false
@onready var wind_button: Button = $WindButton
@onready var wind_progress: TextureProgressBar = $WindButton/WindProgress

func _ready() -> void:
	EventBus.on_change_state.connect(_on_camera_change_state)
	EventBus.camera_finished_moving.connect(_on_camera_finished_moving)
	set_camera.call_deferred("BossCamera")

func _process(_delta: float) -> void:
	if CameraRegistry.activeCamera == "StorageCamera":
		wind_button.visible = true
		wind_progress.max_value = EventBus.maxWind
		wind_progress.value = EventBus.windAmount
	else:
		wind_button.visible = false
	if EventBus.forceCameraForward:
		visible = false

func set_camera(camId: String) -> void:
	CameraRegistry.change_monitor_camera(camId)
	#texture.viewport_path = CameraRegistry.get_camera(camId).get_parent().get_path()

func _on_camera_finished_moving() -> void:
	if _makeVisibleWhenAnimFinished:
		visible = true
		_makeVisibleWhenAnimFinished = false
	else:
		visible = false

func _on_camera_change_state(_oldState: EventBus.CameraState, newState: EventBus.CameraState) -> void:
	if newState == EventBus.CameraState.CAMERAS:
		_makeVisibleWhenAnimFinished = true
	else:
		_makeVisibleWhenAnimFinished = false


func _on_cam_1_button_pressed() -> void:
	set_camera("StorageCamera")

func _on_cam_2_button_pressed() -> void:
	set_camera("OtherCamera")

func _on_exit_button_pressed() -> void:
	EventBus.on_change_state.emit(EventBus.CameraState.CAMERAS, EventBus.CameraState.FORWARD)
	EventBus.showUIButtons = true
	visible = false

func _on_cam_3_button_pressed() -> void:
	set_camera("BossCamera")


func _on_exit_cam_button_pressed() -> void:
	set_camera("ExitCamera")


func _on_printer_cam_button_pressed() -> void:
	set_camera("PrinterCamera")


func _on_corridor_cam_button_pressed() -> void:
	set_camera("CorridorCamera")


func _on_break_room_cam_button_pressed() -> void:
	set_camera("BreakRoomCamera")


func _on_wind_button_button_down() -> void:
	EventBus.begin_wind_up.emit()
func _on_wind_button_button_up() -> void:
	EventBus.end_wind_up.emit()


func _on_break_room_door_cam_button_pressed() -> void:
	set_camera("BreakRoomDoorCamera")
