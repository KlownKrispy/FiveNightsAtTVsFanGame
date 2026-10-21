extends Node2D

enum Difficulty {
	EASY,
	MEDIUM,
	HARD
}

const difficultySizes: Dictionary[Difficulty, Vector2i] = {
	Difficulty.EASY: Vector2i(7, 7),
	Difficulty.MEDIUM: Vector2i(11, 11),
	Difficulty.HARD: Vector2i(15, 15),
}

const difficultyMineRatio: Dictionary[Difficulty, float] = {
	Difficulty.EASY: 0.2,
	Difficulty.MEDIUM: 0.25,
	Difficulty.HARD: 0.35,
}

const difficultyRewards: Dictionary[Difficulty, int] = {
	Difficulty.EASY: 1,
	Difficulty.MEDIUM: 3,
	Difficulty.HARD: 5,
}

@onready var minesweeper_tiles: MinesweeperTileMap = $MinesweeperTiles

@export var difficulty: Difficulty = Difficulty.EASY
@onready var mines: Label = $Mines
@onready var flags: Label = $Flags

func generate() -> void:
	minesweeper_tiles.size = difficultySizes[difficulty]
	minesweeper_tiles.difficultyMultiplier = difficultyMineRatio[difficulty]
	minesweeper_tiles.generate()
	_change_game_visiblity(true)

@onready var game_title_label: Label = $GameTitleLabel
@onready var easy_button: Button = $EasyButton
@onready var medium_button: Button = $MediumButton
@onready var hard_button: Button = $HardButton
@onready var exit_button: Button = $ExitButton
func _change_game_visiblity(gameVisible: bool) -> void:
	var menu := [game_title_label, easy_button, medium_button, hard_button, exit_button]
	var game := [minesweeper_tiles, mines, flags]
	for node in menu:
		node.visible = not gameVisible
	for node in game:
		node.visible = gameVisible

func _process(_delta: float) -> void:
	flags.text = str(minesweeper_tiles.get_flag_count())
	mines.text = str(minesweeper_tiles.get_mine_count())


func _on_easy_button_pressed() -> void:
	difficulty = Difficulty.EASY
	generate()

func _on_medium_button_pressed() -> void:
	difficulty = Difficulty.MEDIUM
	generate()

func _on_hard_button_pressed() -> void:
	difficulty = Difficulty.HARD
	generate()


func _on_minesweeper_tiles_game_lost() -> void:
	_change_game_visiblity(false)

func _on_minesweeper_tiles_game_won() -> void:
	_change_game_visiblity(false)

signal minesweeper_closed
func _on_exit_button_pressed() -> void:
	minesweeper_closed.emit()
