extends Sprite3D

@onready var character_body_3d: DayPlayer = $"../../CharacterBody3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var camera_3d: Camera3D = $SubViewport/Camera3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if character_body_3d == null:
		return
	camera_3d.global_position = (character_body_3d.global_position)
	camera_3d.global_rotation = (character_body_3d.global_rotation)
	if character_body_3d.global_position.distance_to(global_position) >= 8.0:
		return
	#look_at(character_body_3d.global_position)
	#rotation.x = 0
	#rotation.z = 0
	
