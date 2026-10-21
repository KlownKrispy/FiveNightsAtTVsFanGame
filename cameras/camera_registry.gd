extends Node

var activeCamera: String = "player"
var monitor: Sprite2D = null
var _cameraResolution: Vector2i = Vector2i(512, 512)

func set_camera_resolution(res: Vector2i) -> void:
	_cameraResolution = res
	for camID in cameras:
		if camID == "player":
			continue
		var cam = cameras[camID]
		var vp = cam.get_parent()
		if vp is not SubViewport:
			continue
		var svp: SubViewport = vp
		svp.size = _cameraResolution

func change_monitor_camera(id: String) -> void:
	if monitor == null:
		return
	var cam := get_camera(id)
	if monitor.texture is not ViewportTexture:
		monitor.texture = ViewportTexture.new()
	monitor.texture.viewport_path = cam.get_parent().get_path()
	cam.make_current()
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
	var vp = cam.get_parent()
	if vp is not SubViewport:
		return
	var svp: SubViewport = vp
	svp.size = _cameraResolution

func get_cameras() -> Dictionary[String, GameCamera]:
	return cameras

func get_camera(id: String) -> GameCamera:
	assert (id in cameras)	
	return cameras[id]

func try_get_camera(id: String) -> GameCamera:
	if id not in cameras:
		return null
	return cameras[id]
