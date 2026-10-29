extends Sprite2D


var speed := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = randf_range(-32, 64)
	position.x = randf_range(-400, 400)
	speed = randf_range(40.0, 80.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= delta * speed
	if position.x < -400:
		position.x = 400
	if position.x > 400:
		position.x = -400
