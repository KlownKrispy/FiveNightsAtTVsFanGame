extends Control

func _on_games_exit_button_pressed() -> void:
	visible = false

@onready var minesweeper: Node2D = $Minesweeper
@onready var game_picker: Control = $GamePicker

func _on_minesweeper_button_pressed() -> void:
	minesweeper.visible = true
	game_picker.visible = false
