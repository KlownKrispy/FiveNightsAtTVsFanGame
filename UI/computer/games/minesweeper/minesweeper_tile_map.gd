class_name MinesweeperTileMap
extends TileMapLayer

var hoveringOver := Vector2i(-1, -1)
var mineMap: Array[Vector2i] = []
@export var size := Vector2i(7, 7)
## Number of mines in the map, set to negative to use difficulty multiplier instead
@export var mineCount := -1
## Used if Mine Count is negative, is a proportion of the map that should be covered in mines.
@export var difficultyMultiplier = 0.25

var firstClick := true
var gameOver := false
signal game_lost
signal game_won

var _flagCount := 0
func get_flag_count() -> int:
	return _flagCount
func get_mine_count() -> int:
	if firstClick:
		return 0
	return mineMap.size()
func get_remaining_mines() -> int:
	return get_mine_count() - get_flag_count()

func _ready() -> void:
	generate()

func generate() -> void:
	if mineCount < 0:
		# Preserve the sign in case we want to generate a differently sized map later!
		mineCount = -floori(size.x * size.y * difficultyMultiplier)
	var trueMineCount = absi(mineCount)
	mineMap.clear()
	mineMap.resize(trueMineCount)
	# this is actually a set, all values are true
	var freeTiles: Dictionary[Vector2i, bool] = {}
	clear()
	for x in size.x:
		for y in size.y:
			var tilePos := Vector2i(x,y)
			set_cell(tilePos, 0, Vector2i(9, 0))
			freeTiles[tilePos] = true
	for i in trueMineCount:
		var p: Vector2i = freeTiles.keys().pick_random()
		mineMap[i] = p
		freeTiles.erase(p)
	# reposition to be centered
	#position.x += 0.5 * tile_set.tile_size.x * (25 - size.x)
	#position.y += 0.5 * tile_set.tile_size.y * (25 - size.y)
	scale = Vector2(25.0 / size.x, 25.0 / size.y)
	gameOver = false

func _reveal(pos: Vector2i, visited: Array[Vector2i] = []) -> void:
	if not _is_cell_valid(pos):
		return
	if _is_cell_revealed(pos):
		return
	if pos in mineMap:
		_lose()
		set_cell(pos, 0, Vector2i(12, 0))
		return
	visited.append(pos)
	var neighbors = _all_neighbors(pos)
	var mines := _count_mines(pos)
	if mines == 0:
		for neighbor in neighbors:
			if neighbor not in visited:
				_reveal(neighbor, visited)
	set_cell(pos, 0, Vector2i(mines, 0))
func _lose() -> void:
	gameOver = true
	for pos in mineMap:
		if not _is_cell_revealed(pos):
			set_cell(pos, 0, Vector2i(11, 0))
	game_lost.emit()
func _click(pos: Vector2i) -> void:
	if not _is_cell_valid(pos):
		return
	if firstClick:
		# guarantee safety!
		var safety := _all_neighbors(pos)
		if safety.size() == 0:
			return
		safety.append(pos)
		for p in safety:
			mineMap.erase(p)
		firstClick = false
	_reveal(pos)
	_check_win()

func _check_win() -> void:
	if gameOver:
		return
	# conditions: all cells must be revealed (not hover or unrevealed sprites)
	# flags count as 'revealed' by the _is_cell_revealed function
	for x in size.x:
		for y in size.y:
			if not _is_cell_revealed(Vector2i(x, y)):
				return
	game_won.emit()
	gameOver = true

func _flag(pos: Vector2i) -> void:
	if not _is_cell_valid(pos):
		return
	if not _is_cell_revealed(pos):
		set_cell(pos, 0, Vector2i(10, 0))
		_flagCount += 1
		return
	if get_cell_atlas_coords(pos) == Vector2i(10, 0):
		set_cell(pos, 0, Vector2i(13, 0))
		_flagCount -= 1
		return

func _process(_delta: float) -> void:
	if gameOver:
		return
	if not is_visible_in_tree():
		return
	_update_hovered_tile()
	if Input.is_action_just_pressed("minigame_interact"):
		_click(hoveringOver)
	elif Input.is_action_just_pressed("minigame_alt_interact"):
		_flag(hoveringOver)

func _update_hovered_tile() -> void:
	var mousePos := get_local_mouse_position()
	var tilePos := Vector2i(
		floori(mousePos.x / tile_set.tile_size.x),
		floori(mousePos.y / tile_set.tile_size.y)
	)
	if not _is_cell_valid(tilePos):
		_reset_hover()
		return
	var current := get_cell_atlas_coords(tilePos)
	if current.x < 0 or current.y < 0:
		_reset_hover()
		return
	if hoveringOver != tilePos:
		_reset_hover()
	if current == Vector2i(9, 0):
		set_cell(tilePos, 0, Vector2i(13, 0))
	hoveringOver = tilePos

func _reset_hover() -> void:
	if get_cell_atlas_coords(hoveringOver) == Vector2i(13, 0):
		set_cell(hoveringOver, 0, Vector2i(9, 0))
	hoveringOver = Vector2i(-1, -1)

func _count_mines(pos: Vector2i) -> int:
	var n = _all_neighbors(pos)
	var ret := 0
	for p in n:
		if p in mineMap:
			ret += 1
	return ret

func _all_neighbors(pos: Vector2i) -> Array[Vector2i]:
	if pos.x < 0 or pos.x >= size.x:
		return []
	if pos.y < 0 or pos.y >= size.y:
		return []
	var ret: Array[Vector2i] = []
	for x in range(-1, 2):
		for y in range(-1, 2):
			if x == 0 and y == 0:
				continue
			var np = Vector2i(x,y) + pos
			if np.x < 0 or np.y < 0:
				continue
			if np.x >= size.x or np.y >= size.y:
				continue
			ret.append(np)
	return ret

func _is_cell_revealed(pos: Vector2i) -> bool:
	if not _is_cell_valid(pos):
		return false
	var atlas := get_cell_atlas_coords(pos)
	const unrevealedAtlases := [Vector2i(9, 0), Vector2i(13, 0)]
	return atlas not in unrevealedAtlases

func _is_cell_valid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < size.x and pos.y < size.y
