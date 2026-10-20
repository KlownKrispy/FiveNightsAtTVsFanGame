extends Camera3D
@onready var camera_animator: AnimationPlayer = $CameraAnimator
@onready var interact_ray: RayCast3D = $InteractRay
@onready var flashlight: SpotLight3D = $Flashlight

@export var INTERACTION_RAY_LENGTH := 4.0
func _ready() -> void:
	EventBus.on_change_state.connect(_on_camera_change_state)
	CameraRegistry.set_player_camera(self)

func _physics_process(_delta: float) -> void:
	var mousePos = get_viewport().get_mouse_position()
	interact_ray.global_position = project_ray_origin(mousePos)
	interact_ray.target_position = INTERACTION_RAY_LENGTH * project_local_ray_normal(mousePos)
func _input(event: InputEvent) -> void:
	if EventBus.currentCameraState != EventBus.CameraState.CAMERAS:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return
	if not canClickScreen:
		return
	if not interact_ray.is_colliding():
		return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var object := interact_ray.get_collider()
	if object.get_parent() is not ComputerScreen:
		return
	var area: Area3D = object
	"""
	if event is InputEventMouse:
		var transformedPosition := interact_ray.get_collision_point()
		transformedPosition = area.to_local(transformedPosition)
		const resolution := Vector2(683, 512)
		const areaSize := Vector3(0.4 * 4.0/3.0, 0.4, 0.01)
		transformedPosition /= areaSize
		transformedPosition.y *= -1.0
		transformedPosition.y -= 0.025
		transformedPosition += Vector3.ONE * 0.5
		var mousePos := Vector2(transformedPosition.x, transformedPosition.y)
		mousePos *= resolution
		event.position = mousePos
	"""
	if event is InputEventMouse:
		var cs: ComputerScreen = area.get_parent()
		var cursor: Node2D = cs.get_node("Cursor")
		event.position = cursor.position
	area.get_viewport().push_input(event)
func _process(_delta: float) -> void:
	if EventBus.forceCameraForward:
		if EventBus.currentCameraState != EventBus.CameraState.FORWARD:
			EventBus.on_change_state.emit(EventBus.currentCameraState, EventBus.CameraState.FORWARD)
		camera_animator.speed_scale = 2.0
		return
	flashlight.visible = Input.is_action_pressed("flashlight")
	if Input.is_action_just_pressed("flashlight"):
		EventBus.flashlight_triggered.emit()
	if interact_ray.is_colliding():
		var object := interact_ray.get_collider()
		# TODO
		if object.name == "Computer" and Input.is_action_just_pressed("interact"):
			EventBus.on_change_state.emit(EventBus.CameraState.FORWARD, EventBus.CameraState.CAMERAS)
			EventBus.showUIButtons = false
			interact_ray.collision_mask = 0x4
	else:
		Input.set_custom_mouse_cursor(null)

var _changingToForward := false
func _on_camera_change_state(oldState: EventBus.CameraState, newState: EventBus.CameraState) -> void:
	_changingToForward = false
	canClickScreen = false
	match newState:
		EventBus.CameraState.LEFT:
			interact_ray.enabled = false
			camera_animator.play("look_left")
		EventBus.CameraState.RIGHT:
			interact_ray.enabled = false
			camera_animator.play("look_right")
		EventBus.CameraState.FORWARD:
			_changingToForward = true
			if oldState == EventBus.CameraState.LEFT:
				camera_animator.play("return_from_left")
			elif oldState == EventBus.CameraState.RIGHT:
				camera_animator.play("return_from_right")
			elif oldState == EventBus.CameraState.CAMERAS:
				camera_animator.play("return_from_monitor")
			elif oldState == EventBus.CameraState.HIDE:
				camera_animator.play("return_from_hide")
		EventBus.CameraState.CAMERAS:
			interact_ray.enabled = true
			camera_animator.play("show_monitor")
		EventBus.CameraState.HIDE:
			interact_ray.enabled = false
			camera_animator.play("hide")

var canClickScreen := true

func _on_camera_animator_animation_finished(_anim_name: StringName) -> void:
	EventBus.camera_finished_moving.emit()
	canClickScreen = true
	if _changingToForward:
		interact_ray.enabled = true
		interact_ray.collision_mask = 0x2
