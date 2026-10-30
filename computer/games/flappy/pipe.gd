class_name FlappyPipe
extends Node2D

@onready var bottom_base: Sprite2D = $Bottom/Base
@onready var bottom_body: Sprite2D = $Bottom/Body
@onready var bottom_lip: Sprite2D = $Bottom/Lip
@onready var top_base: Sprite2D = $Top/Base
@onready var top_body: Sprite2D = $Top/Body
@onready var top_lip: Sprite2D = $Top/Lip
@onready var top_collider: CollisionShape2D = $TopCollider
@onready var bottom_collider: CollisionShape2D = $BottomCollider
@export var baseSpeed := 100.0
signal reached_end

var speedMultiplier := 1.0
func _get_speed() -> float:
	return baseSpeed * speedMultiplier

func score_update(score: int) -> void:
	var newGamePlusScore: int = int(MinigameTracker.flappyLifetimeScore * 0.75)
	var effectiveScore: int = score + newGamePlusScore
	speedMultiplier = 1.0 + effectiveScore / 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_randomize_stats()

func _randomize_stats():
	var bottomHeightPixels := randi_range(30, 80)
	var bottomRect: RectangleShape2D = RectangleShape2D.new()
	bottomRect.size = Vector2(28, bottomHeightPixels)
	bottom_collider.shape = bottomRect
	bottom_body.scale.x = 2
	bottom_body.scale.y = 2 * bottomHeightPixels
	bottom_body.position.y = -8 - bottomHeightPixels
	bottom_lip.position.y = -14 - 2 * bottomHeightPixels
	var topHeightPixels := randi_range(30, 80)
	var topRect: RectangleShape2D = RectangleShape2D.new()
	topRect.size = Vector2(28, topHeightPixels)
	top_collider.shape = topRect
	top_body.scale.x = 2
	top_body.scale.y = 2 * topHeightPixels
	top_body.position.y = -8 - topHeightPixels
	top_lip.position.y = -14 - 2 * topHeightPixels

func _physics_process(delta: float) -> void:
	position.x -= delta * _get_speed()
	if position.x <= -800:
		reached_end.emit()
		queue_free()
