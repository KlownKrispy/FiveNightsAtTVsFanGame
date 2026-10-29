class_name ComputerGamesUI
extends Control

func pause() -> void:
	if tetris.visible:
		tetris.process_mode = Node.PROCESS_MODE_DISABLED
	if flappy.visible:
		flappy.process_mode = Node.PROCESS_MODE_DISABLED
func unpause() -> void:
	if tetris.visible:
		tetris.process_mode = Node.PROCESS_MODE_INHERIT
	if flappy.visible:
		flappy.process_mode = Node.PROCESS_MODE_INHERIT

func _on_games_exit_button_pressed() -> void:
	visible = false

@onready var minesweeper: Node2D = $Minesweeper
@onready var game_picker: Control = $GamePicker
@onready var tetris: Node2D = $Tetris
@onready var flappy: Node2D = $Flappy

func _on_minesweeper_button_pressed() -> void:
	minesweeper.visible = true
	game_picker.visible = false
	unpause()

func _on_minesweeper_minesweeper_closed() -> void:
	pause()
	minesweeper.visible = false
	game_picker.visible = true

func _on_tetris_button_pressed() -> void:
	game_picker.visible = false
	tetris.visible = true
	unpause()

func _on_tetris_tile_map_game_over() -> void:
	pause()
	tetris.visible = false
	game_picker.visible = true

func _on_flappy_button_pressed() -> void:
	game_picker.visible = false
	flappy.visible = true
	unpause()
