extends CharacterBody2D

@export var gravity := Vector2(0, 500)
@export var jumpVelocity := Vector2(0, -250)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var dead := false

signal died
signal scored

func _physics_process(delta: float) -> void:
	velocity += gravity * delta
	if Input.is_action_just_pressed("flappy_flap") and not dead:
		if velocity.y > 0:
			velocity = jumpVelocity
		else:
			velocity += jumpVelocity
		if velocity.y < -500:
			velocity.y = -500
		animated_sprite_2d.play("flap")
	move_and_slide()
	if not dead and (is_on_ceiling() or is_on_wall() or is_on_floor()):
		dead = true
		animated_sprite_2d.play("die")
		velocity = Vector2.ZERO
		died.emit()


func _on_score_checker_area_entered(_area: Area2D) -> void:
	if not dead:
		scored.emit()
