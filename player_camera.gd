extends Camera3D
@onready var camera_animator: AnimationPlayer = $CameraAnimator
@onready var interact_ray: RayCast3D = $InteractRay
@onready var flashlight: SpotLight3D = $Flashlight

@export var INTERACTION_RAY_LENGTH := 4.0
func _ready() -> void:
	UIEvent.on_change_state.connect(_on_camera_change_state)
	CameraRegistry.set_player_camera(self)

func _physics_process(_delta: float) -> void:
	var mousePos = get_viewport().get_mouse_position()
	interact_ray.global_position = project_ray_origin(mousePos)
	interact_ray.target_position = INTERACTION_RAY_LENGTH * project_local_ray_normal(mousePos)
func _process(_delta: float) -> void:
	if UIEvent.forceCameraForward:
		if UIEvent.currentCameraState != UIEvent.CameraState.FORWARD:
			UIEvent.on_change_state.emit(UIEvent.currentCameraState, UIEvent.CameraState.FORWARD)
		camera_animator.speed_scale = 2.0
		return
	flashlight.visible = Input.is_action_pressed("flashlight")
	if Input.is_action_just_pressed("flashlight"):
		UIEvent.flashlight_triggered.emit()
	if Input.is_action_just_pressed("interact") and interact_ray.is_colliding():
		var object := interact_ray.get_collider()
		# TODO
		if object.name == "Computer":
			UIEvent.on_change_state.emit(UIEvent.CameraState.FORWARD, UIEvent.CameraState.CAMERAS)
			UIEvent.showUIButtons = false

var _changingToForward := false
func _on_camera_change_state(oldState: UIEvent.CameraState, newState: UIEvent.CameraState) -> void:
	_changingToForward = false
	match newState:
		UIEvent.CameraState.LEFT:
			interact_ray.enabled = false
			camera_animator.play("look_left")
		UIEvent.CameraState.RIGHT:
			interact_ray.enabled = false
			camera_animator.play("look_right")
		UIEvent.CameraState.FORWARD:
			_changingToForward = true
			if oldState == UIEvent.CameraState.LEFT:
				camera_animator.play("return_from_left")
			elif oldState == UIEvent.CameraState.RIGHT:
				camera_animator.play("return_from_right")
			elif oldState == UIEvent.CameraState.CAMERAS:
				camera_animator.play("return_from_monitor")
			elif oldState == UIEvent.CameraState.HIDE:
				camera_animator.play("return_from_hide")
		UIEvent.CameraState.CAMERAS:
			interact_ray.enabled = false
			camera_animator.play("show_monitor")
		UIEvent.CameraState.HIDE:
			interact_ray.enabled = false
			camera_animator.play("hide")


func _on_camera_animator_animation_finished(_anim_name: StringName) -> void:
	UIEvent.camera_finished_moving.emit()
	if _changingToForward:
		interact_ray.enabled = true
