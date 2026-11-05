extends CharacterBody3D
@onready var camera_3d: Camera3D = $Camera3D

@export var speed := 4.0
@export var friction := 16.0
@export var sensitivity := Vector2(0.5, 0.5)

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

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("fps_left", "fps_right", "fps_forward", "fps_backward")
	if direction == Vector2.ZERO:
		velocity = velocity.move_toward(Vector3.ZERO, delta * friction)
	else:
		var direction3D = Vector3(direction.x, 0, direction.y)
		direction3D *= speed
		velocity = basis * direction3D
	move_and_slide()
	if lastMouseMotion != Vector2.ZERO:
		targetCameraAngle += -lastMouseMotion * sensitivity * delta
		targetCameraAngle.y = clampf(targetCameraAngle.y, -PI/2, PI/2)
		rotation.y = targetCameraAngle.x
		camera_3d.rotation.x = targetCameraAngle.y
		lastMouseMotion = Vector2.ZERO
