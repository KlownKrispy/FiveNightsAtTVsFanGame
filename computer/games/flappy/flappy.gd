
extends Node2D

@onready var pipes: Node2D = $Pipes
@onready var bird: CharacterBody2D = $Bird

func reset():
	pipes.process_mode = Node.PROCESS_MODE_INHERIT
	score = 0
	score_label.text = "You passed " + str(score) + " pipes!"
	pipes.update_score(score)
	pipes.reset()
	bird.reset()
@onready var game_over_window: NinePatchRect = $GameOverWindow

func _on_bird_died() -> void:
	MinigameTracker.add_flappy_pipes(score)
	score = 0
	pipes.update_score(score)
	pipes.process_mode = Node.PROCESS_MODE_DISABLED
	game_over_window.visible = true

@onready var score_label: Label = $ScoreLabel

var score: int = 0
func _on_bird_scored() -> void:
	score += 1
	score_label.text = "You passed " + str(score) + " pipes!"
	pipes.update_score(score)

signal game_quit
func _on_quit_button_pressed() -> void:
	game_over_window.visible = false
	reset()
	game_quit.emit()

func _on_replay_button_pressed() -> void:
	game_over_window.visible = false
	reset()
