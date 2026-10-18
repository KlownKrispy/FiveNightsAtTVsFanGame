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

func _ready() -> void:
	generate()

func generate() -> void:
	minesweeper_tiles.size = difficultySizes[difficulty]
	minesweeper_tiles.difficultyMultiplier = difficultyMineRatio[difficulty]
	minesweeper_tiles.generate()

func _process(_delta: float) -> void:
	flags.text = str(minesweeper_tiles.get_flag_count())
	mines.text = str(minesweeper_tiles.get_mine_count())
