class_name GameCamera
extends Camera3D

@export var rotate_axis := Vector3.UP
@export var minAngleDegrees := -15.0
@export var maxAngleDegrees :=  15.0
@export var rotateSpeedDegrees := 5.0
@export var cameraID := "null"
var direction = 1
var previousAngle := 0.0

func _ready() -> void:
	if cameraID == "null":
		cameraID = name
	CameraRegistry.register_camera(cameraID, self)

func _physics_process(_delta: float) -> void:
	var angleDelta: float = _delta * rotateSpeedDegrees * direction
	var newAngle := previousAngle + angleDelta
	if newAngle < minAngleDegrees:
		newAngle = minAngleDegrees
		direction *= -1
	if newAngle > maxAngleDegrees:
		newAngle = maxAngleDegrees
		direction *= -1
	rotate_object_local(rotate_axis, -deg_to_rad(previousAngle))
	rotate_object_local(rotate_axis, deg_to_rad(newAngle))
	previousAngle = newAngle
