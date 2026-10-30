extends Node

var minesweeperLifetimeClears: int = 0
var tetrisLifetimeLinesCleared: int = 0
var flappyLifetimeScore: int = 0

func add_tetris_lines(lines: int) -> void:
	tetrisLifetimeLinesCleared += lines
func add_flappy_pipes(pipes: int) -> void:
	flappyLifetimeScore += pipes
func win_minesweeper() -> void:
	minesweeperLifetimeClears += 1

func reset():
	minesweeperLifetimeClears = 0
	tetrisLifetimeLinesCleared = 0
	flappyLifetimeScore = 0

func _ready() -> void:
	reset()
