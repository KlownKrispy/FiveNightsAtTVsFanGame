extends Node2D

const PIPE = preload("uid://carqpuv5o13is")
@export var horizontalSpacing := 256

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(8):
		add_pipe(horizontalSpacing * i)

func add_pipe_after_last() -> void:
	var maxPosition := -horizontalSpacing
	for child in get_children():
		if child is not Node2D:
			continue
		if child.position.x > maxPosition:
			maxPosition = child.position.x
	var newPosition := maxPosition + horizontalSpacing
	add_pipe(newPosition)

func add_pipe(x: float):
	var pipe := PIPE.instantiate()
	pipe.position.x = x
	pipe.reached_end.connect(_pipe_reached_end)
	add_child(pipe)

func _pipe_reached_end() -> void:
	add_pipe_after_last()
