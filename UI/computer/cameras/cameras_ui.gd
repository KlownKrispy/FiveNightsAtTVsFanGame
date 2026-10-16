extends Control
@onready var camera_view: Sprite2D = $CameraView
@export var camera_res := Vector2i(667, 440)
@onready var wind_button: Button = $WindButton
@onready var wind_progress: TextureProgressBar = $WindButton/WindProgress

func _ready() -> void:
	CameraRegistry.monitor = camera_view
	set_camera.call_deferred("BossCamera")
	CameraRegistry.set_camera_resolution(camera_res)

func _process(_delta: float) -> void:
	if CameraRegistry.activeCamera == "StorageCamera":
		wind_button.visible = true
		wind_progress.max_value = UIEvent.maxWind
		wind_progress.value = UIEvent.windAmount
	else:
		wind_button.visible = false
	if UIEvent.forceCameraForward:
		visible = false

@onready var noise_player: AnimationPlayer = $NoiseOverlay/NoisePlayer

func set_camera(camID: String):
	CameraRegistry.change_monitor_camera(camID)
	noise_player.stop()
	noise_player.play("run")

func _on_printer_button_pressed() -> void:
	set_camera("PrinterCamera")
func _on_boss_button_pressed() -> void:
	set_camera("BossCamera")
func _on_exit_button_pressed() -> void:
	set_camera("ExitCamera")
func _on_cubicle_button_pressed() -> void:
	set_camera("CubicleCamera")
func _on_storage_button_pressed() -> void:
	set_camera("StorageCamera")
func _on_corridor_button_pressed() -> void:
	set_camera("CorridorCamera")
func _on_break_room_button_pressed() -> void:
	set_camera("BreakRoomCamera")
func _on_break_room_door_button_pressed() -> void:
	set_camera("BreakRoomDoorCamera")


func _on_cameras_exit_button_pressed() -> void:
	visible = false

func _on_wind_button_button_up() -> void:
	UIEvent.end_wind_up.emit()

func _on_wind_button_button_down() -> void:
	UIEvent.begin_wind_up.emit()
