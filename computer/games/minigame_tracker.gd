extends Node

var minesweeperLifetimeClears: int = 0
var tetrisLifetimeLinesCleared: int = 0
var flappyLifetimeScore: int = 0

var _partialScoreTetris: int = 0
var _partialScoreFlappy: int = 0

var pointsToScoreTetris: int = 4
var pointsToScoreFlappy: int = 2

func add_tetris_lines(lines: int) -> void:
	tetrisLifetimeLinesCleared += lines
	var coins := int(floor(lines / float(pointsToScoreTetris)))
	_partialScoreTetris += lines % pointsToScoreTetris
	coins += int(floor(_partialScoreTetris / float(pointsToScoreTetris)))
	_partialScoreTetris = _partialScoreTetris % pointsToScoreTetris
	add_coins(coins)
func add_flappy_pipes(pipes: int) -> void:
	flappyLifetimeScore += pipes
	var coins := int(floor(pipes / float(pointsToScoreFlappy)))
	_partialScoreFlappy += pipes % pointsToScoreFlappy
	coins += int(floor(_partialScoreFlappy / float(pointsToScoreFlappy)))
	_partialScoreFlappy = _partialScoreFlappy % pointsToScoreFlappy
	add_coins(coins)
func win_minesweeper() -> void:
	minesweeperLifetimeClears += 1
	add_coins(5)

var coinsBalance: int = 0
var lifetimeCoins: int = 0

func reset():
	minesweeperLifetimeClears = 0
	tetrisLifetimeLinesCleared = 0
	flappyLifetimeScore = 0
	coinsBalance = 0
	lifetimeCoins = 0

signal coins_changed(amount: int, total: int)

func _ready() -> void:
	reset()

func add_coins(amount: int):
	coinsBalance += amount
	if amount >= 0:
		lifetimeCoins += amount
	coins_changed.emit(amount, coinsBalance)
