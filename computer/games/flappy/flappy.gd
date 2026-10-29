
extends Node2D

@onready var pipes: Node2D = $Pipes

func reset():
	pipes.process_mode = Node.PROCESS_MODE_INHERIT

func _on_bird_died() -> void:
	pipes.process_mode = Node.PROCESS_MODE_DISABLED

@onready var score_label: Label = $ScoreLabel

var score: int = 0
func _on_bird_scored() -> void:
	score += 1
	score_label.text = "You passed " + str(score) + " pipes!"
