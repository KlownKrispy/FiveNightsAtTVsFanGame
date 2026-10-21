extends Control
@onready var camera_view: Sprite2D = $CameraView
@export var camera_res := Vector2i(667, 440)

func _ready() -> void:
	CameraRegistry.monitor = camera_view
	set_camera.call_deferred("BossCamera")
	CameraRegistry.set_camera_resolution(camera_res)

func _process(_delta: float) -> void:
	if EventBus.forceCameraForward:
		visible = false

@onready var noise_player: AnimationPlayer = $NoiseOverlay/NoisePlayer
@onready var storage_minigame: Control = $StorageMinigame
@onready var printer_minigame: PrinterMinigame = $PrinterMinigame

func set_camera(camID: String):
	CameraRegistry.change_monitor_camera(camID)
	noise_player.stop()
	noise_player.play("run")
	storage_minigame.visible = (camID == "StorageCamera")
	printer_minigame.handle_visibility(camID)

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
