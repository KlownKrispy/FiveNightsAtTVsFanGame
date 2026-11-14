class_name DayPlayer
extends CharacterBody3D
@onready var camera_3d: Camera3D = $Camera3D

@export var speed := 4.0
@export var friction := 16.0
@export var sensitivity := Vector2(0.25, 0.25)
@export var cameraUpdateSpeed := 100.0

var lastMouseMotion := Vector2.ZERO
var targetCameraAngle := Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is not InputEventMouse:
		return
	if event is InputEventMouseMotion:
		var mevent: InputEventMouseMotion = event
		var rel := mevent.relative
		lastMouseMotion += rel
		return
@onready var interact_ray: RayCast3D = $Camera3D/InteractRay

func _interact() -> bool:
	if not interact_ray.is_colliding():
		return false
	if interact_ray.get_collider() is not Node3D:
		return false
	var collider: Node = interact_ray.get_collider()
	while collider != get_tree().root:
		if "interact" in collider:
			if collider.interact is Callable:
				break
		collider = collider.get_parent()
	if "interact" not in collider:
		return false
	if collider.interact is not Callable:
		return false
	collider.interact(self)
	return true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if not _interact():
			Dialogue.hide()

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("fps_left", "fps_right", "fps_forward", "fps_backward")
	if direction == Vector2.ZERO:
		velocity.x = lerpf(velocity.x, 0, delta * friction)
		velocity.z = lerpf(velocity.z, 0, delta * friction)
	else:
		var direction3D = Vector3(direction.x, 0, direction.y)
		direction3D *= speed
		var vec: Vector3 = basis * direction3D
		velocity.x = vec.x
		velocity.z = vec.z
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	if lastMouseMotion != Vector2.ZERO:
		targetCameraAngle += -lastMouseMotion * sensitivity * delta
		targetCameraAngle.y = clampf(targetCameraAngle.y, -PI/2, PI/2)
		lastMouseMotion = Vector2.ZERO
	_update_camera_angle(delta)

func _update_camera_angle(_delta: float) -> void:
	rotation.y = targetCameraAngle.x
	camera_3d.rotation.x = targetCameraAngle.y
	return
func _update_camera_angle_hmm(delta: float) -> void:
	var weight := 1.0 - exp(-delta * cameraUpdateSpeed)
	rotation.y = lerp_angle(rotation.y, targetCameraAngle.x, weight)
	camera_3d.rotation.x = lerp_angle(camera_3d.rotation.x, targetCameraAngle.y, weight)
