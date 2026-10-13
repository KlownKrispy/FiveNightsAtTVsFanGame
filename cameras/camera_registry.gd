extends Node

var activeCamera: String = "player"
var monitor: Sprite3D = null

func change_monitor_camera(id: String) -> void:
	if monitor == null:
		return
	var cam := get_camera(id)
	monitor.texture.viewport_path = cam.get_parent().get_path()
	activeCamera = id

var cameras: Dictionary[String, GameCamera] = {}
var playerCamera: Camera3D = null

func _ready() -> void:
	cameras["player"] = null # just preallocate this one

func set_player_camera(cam: Camera3D) -> void:
	playerCamera = cam
func get_player_camera() -> Camera3D:
	return playerCamera

func register_camera(id: String, cam: GameCamera) -> void:
	assert (id not in cameras)
	cameras[id] = cam

func get_cameras() -> Dictionary[String, GameCamera]:
	return cameras

func get_camera(id: String) -> GameCamera:
	assert (id in cameras)
	return cameras[id]

func try_get_camera(id: String) -> GameCamera:
	if id not in cameras:
		return null
	return cameras[id]
