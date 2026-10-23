extends Control

func _on_games_exit_button_pressed() -> void:
	visible = false

@onready var minesweeper: Node2D = $Minesweeper
@onready var game_picker: Control = $GamePicker
@onready var tetris: Node2D = $Tetris

func _on_minesweeper_button_pressed() -> void:
	minesweeper.visible = true
	game_picker.visible = false

func _on_minesweeper_minesweeper_closed() -> void:
	minesweeper.visible = false
	game_picker.visible = true

func _on_tetris_button_pressed() -> void:
	game_picker.visible = false
	tetris.visible = true
