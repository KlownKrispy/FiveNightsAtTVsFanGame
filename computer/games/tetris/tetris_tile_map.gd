extends TileMapLayer

@export var bagSize: int = 1

enum Piece {
	LINE,
	J,
	S,
	L,
	Z,
	SQUARE,
	T,
}
@onready var drop_timer: Timer = $DropTimer

var bag: Array = []

var currentPieceType: Piece = Piece.LINE
var currentPiece: Array[Vector2i] = []
var currentRotation: int = 0

@export var boardSize := Vector2i(10, 20)

func _ready():
	reset()

func reset():
	_init_bag()
	_setup_board()
	if not is_visible_in_tree():
		_pause()

func _cell_empty(pos: Vector2i) -> bool:
	if pos.y < 0 or pos.y >= boardSize.y:
		return false
	if pos.x < 0 or pos.x >= boardSize.x:
		return false
	if get_cell_source_id(pos) != -1:
		return false
	return true

func _setup_board() -> void:
	clear()
	for i in 2 + boardSize.x:
		var borderTop    := Vector2i(-1 + i, -1)
		var borderBottom := Vector2i(-1 + i, boardSize.y)
		set_cell(borderTop, 0, Vector2i.ZERO)
		set_cell(borderBottom, 0, Vector2i.ZERO)
	for i in 2 + boardSize.y:
		var borderLeft    := Vector2i(-1, -1 + i)
		var borderRight := Vector2i(boardSize.x, -1 + i)
		set_cell(borderLeft, 0, Vector2i.ZERO)
		set_cell(borderRight, 0, Vector2i.ZERO)

@onready var piece_preview: TileMapLayer = $PiecePreview
func _update_preview() -> void:
	piece_preview.clear()
	var dropDistance = _get_drop_distance()
	for p in currentPiece:
		var np = p + dropDistance * Vector2i.DOWN
		var tileIndex: int = 1 + int(currentPieceType)
		piece_preview.set_cell(np, 0, Vector2i(tileIndex, 0))

func _generate_new_piece() -> void:
	@warning_ignore("integer_division")
	currentPiece = _generate_new_piece_at(currentPieceType, Vector2i(int(boardSize.x / 2), 0))
	var tileIndex: int = 1 + int(currentPieceType)
	for pos in currentPiece:
		if get_cell_atlas_coords(pos) != Vector2i(-1, -1):
			_lose()
		set_cell(pos, 0, Vector2i(tileIndex, 0))

func _generate_new_piece_at(pieceType: Piece, topMid: Vector2i) -> Array[Vector2i]:
	# First entry is the origin of the rotation!
	match pieceType:
		Piece.LINE:
			return [
				topMid,
				topMid + Vector2i.LEFT,
				topMid + Vector2i.RIGHT,
				topMid + Vector2i.RIGHT * 2
			]
		Piece.J:
			return [
				topMid + Vector2i.DOWN,
				topMid + Vector2i(-1, 1),
				topMid + Vector2i.LEFT,
				topMid + Vector2i(1,  1)
			]
		Piece.Z:
			return [
				topMid + Vector2i.DOWN,
				topMid,
				topMid + Vector2i.LEFT,
				topMid + Vector2i(1, 1)
			]
		Piece.L:
			return [
				topMid + Vector2i.DOWN,
				topMid + Vector2i(-1, 1),
				topMid + Vector2i.RIGHT,
				topMid + Vector2i(1, 1)
			]
		Piece.S:
			return [
				topMid + Vector2i.DOWN,
				topMid,
				topMid + Vector2i.RIGHT,
				topMid + Vector2i(-1, 1)
			]
		Piece.SQUARE:
			return [
				topMid + Vector2i.DOWN,
				topMid,
				topMid + Vector2i.RIGHT,
				topMid + Vector2i(1, 1)
			]
		Piece.T:
			return [
				topMid + Vector2i.DOWN,
				topMid,
				topMid + Vector2i(-1, 1),
				topMid + Vector2i( 1, 1)
			]
	return []

var moveTimer := 0.0

var srsTests: Dictionary[int, Array] = {
	0: [Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO],
	1: [Vector2i.ZERO, Vector2i(1,0), Vector2i(1,-1), Vector2i(0,2), Vector2i(1,2)],
	2: [Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO],
	3: [Vector2i.ZERO, Vector2i(-1,0), Vector2i(-1,-1), Vector2i(0,2), Vector2i(-1,2)],
}
var srsTestsLine: Dictionary[int, Array] = {
	0: [Vector2i.ZERO, Vector2i(-1,0), Vector2i(2,0), Vector2i(-1,0), Vector2i(2,0)],
	1: [Vector2i(-1,0), Vector2i.ZERO, Vector2i.ZERO, Vector2i(0,1), Vector2i(0,-2)],
	2: [Vector2i(-1,1), Vector2i(1,1), Vector2i(-2,1), Vector2i(1,0), Vector2i(-2,0)],
	3: [Vector2i(0,1), Vector2i(0,1), Vector2i(0,1), Vector2i(0,-1), Vector2i(0,2)],
}

func _rotate_generic(dir: int, testsSet: Dictionary[int, Array]):
	var newRotation = posmod(currentRotation + dir, 4)
	var tests = testsSet[newRotation]
	var oldtests = testsSet[currentRotation]
	var newPositions: Array[Vector2i] = []
	for i in tests.size():
		newPositions.clear()
		var test = tests[i]
		var oldtest = oldtests[i]
		var adjusted = oldtest - test
		var testPassed := true
		var origin := currentPiece[0]
		for p in currentPiece:
			var np = p - origin
			if dir == -1:
				np = Vector2i(np.y, -np.x)
			elif dir == 1:
				np = Vector2i(-np.y, np.x)
			np = np + adjusted + origin
			newPositions.append(np)
			if np in currentPiece:
				continue
			if not _cell_empty(np):
				testPassed = false
				break
		if testPassed:
			break
		if i == tests.size() - 1:
			return # failed to rotate
	currentRotation = newRotation
	for p in currentPiece:
		set_cell(p, -1)
	for i in currentPiece.size():
		currentPiece[i] = newPositions[i]
		var tileIndex := int(currentPieceType) + 1
		set_cell(currentPiece[i], 0, Vector2i(tileIndex, 0))
func _rotate_line(dir: int) -> void:
	_rotate_generic(dir, srsTestsLine)
func _rotate_square(_dir: int) -> void:
	return

func _rotate_dir(dir: int) -> void:
	if dir == 0:
		return
	if currentPieceType == Piece.LINE:
		_rotate_line(dir)
		return
	if currentPieceType == Piece.SQUARE:
		_rotate_square(dir)
		return
	_rotate_generic(dir, srsTests)
func _rotate_cw() -> void:
	_rotate_dir(1)
	_update_preview()
func _rotate_ccw() -> void:
	_rotate_dir(-1)
	_update_preview()

var heldPiece: int = -1
@onready var hold_piece: TileMapLayer = $HoldLabel/HoldPiece

func _update_held() -> void:
	hold_piece.clear()
	var topMid := Vector2i(1, 0)
	var piece := _generate_new_piece_at(heldPiece, topMid)
	var tileIndex := int(heldPiece) + 1
	for p in piece:
		hold_piece.set_cell(p, 0, Vector2i(tileIndex, 0))

var canHold := true
func _hold() -> void:
	if not canHold:
		return
	if heldPiece == -1:
		heldPiece = currentPieceType
		for p in currentPiece:
			set_cell(p, -1)
		_take_piece()
		_update_held()
		_update_preview()
		canHold = false
		return
	var backup := currentPieceType
	currentPieceType = heldPiece as Piece
	heldPiece = backup
	for p in currentPiece:
		set_cell(p, -1)
	_generate_new_piece()
	_update_held()
	_update_preview()
	canHold = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("tetris_cw"):
		_rotate_cw()
	if Input.is_action_just_pressed("tetris_ccw"):
		_rotate_ccw()
	if Input.is_action_just_pressed("tetris_hard_drop"):
		_hard_drop()
	if Input.is_action_just_pressed("tetris_hold"):
		_hold()
	if Input.is_action_just_pressed("tetris_left"):
		_try_move(-1)
		moveTimer = 0
	if Input.is_action_just_pressed("tetris_right"):
		_try_move(1)
		moveTimer = 0
	if Input.is_action_pressed("tetris_left") or Input.is_action_pressed("tetris_left"):
		moveTimer += delta
	else:
		moveTimer = 0
	if moveTimer >= 0.25:
		var moveDir: int = 0
		if Input.is_action_pressed("tetris_left"):
			moveDir += -1
		if Input.is_action_pressed("tetris_right"):
			moveDir += +1
		_try_move(moveDir)
		moveTimer = 0
	if Input.is_action_pressed("tetris_soft_drop"):
		drop_timer.wait_time = 0.125
		if drop_timer.time_left > drop_timer.wait_time:
			drop_timer.start(drop_timer.wait_time)
	else:
		drop_timer.wait_time = 0.5

signal game_over
func _lose() -> void:
	game_over.emit()
	reset()

func _take_piece() -> void:
	currentPieceType = bag.pop_front()
	currentRotation = 0
	_generate_new_piece()
	_try_replenish_bag()
	_update_preview()
	_update_next()

@onready var next_pieces: TileMapLayer = $NextLabel/NextPieces
@export var nextCount := 4
func _update_next() -> void:
	next_pieces.clear()
	for i in nextCount:
		var topMid := Vector2i(1, 4 * i)
		var piece := _generate_new_piece_at(bag[i], topMid)
		var tileIndex := int(bag[i]) + 1
		for p in piece:
			next_pieces.set_cell(p, 0, Vector2i(tileIndex, 0))

func _try_replenish_bag():
	var bagMaxSize = bagSize * 7
	if bag.size() <= bagMaxSize: # less than half, since we have two bags actually
		var newPieces := Piece.values()
		var baghalf = []
		for i in bagMaxSize:
			baghalf += newPieces
		baghalf.shuffle()
		bag += newPieces

func _init_bag():
	if not bag.is_empty():
		return
	var bagHalf = []
	var pieceSet = Piece.values()
	for i in bagSize:
		bagHalf += pieceSet
	bagHalf.shuffle()
	bag += bagHalf
	bagHalf.shuffle()
	bag += bagHalf
	_take_piece()

func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
	if not is_visible_in_tree():
		_pause()
	else:
		_unpause()

func _unpause() -> void:
	drop_timer.paused = false
	lock_timer.paused = false

func _pause() -> void:
	drop_timer.paused = true
	lock_timer.paused = true

var lines: int = 0
func _check_board() -> void:
	var finishedRows: Array[int] = []
	for y in boardSize.y:
		var rowComplete := true
		for x in boardSize.x:
			if _cell_empty(Vector2i(x, y)):
				rowComplete = false
				break
		if not rowComplete:
			continue
		finishedRows.append(y)
	if finishedRows.is_empty():
		return
	lines += finishedRows.size()
	var unclearedLines: Array[int] = []
	var ny := boardSize.y - 1
	for y in range(boardSize.y-1, -1, -1):
		if y in finishedRows:
			continue
		unclearedLines.append(y)
	for y in unclearedLines:
		if y == ny:
			ny -= 1
			continue # no need to copy back
		for x in boardSize.x:
			var copyFrom := Vector2i(x, y)
			var copyTo := Vector2i(x, ny)
			set_cell(copyTo, get_cell_source_id(copyFrom), get_cell_atlas_coords(copyFrom))
			set_cell(copyFrom, -1)
		ny -= 1

func _lock_position() -> void:
	canHold = true
	_check_board()
	_take_piece()

func _try_move(dir: int) -> void:
	if dir == 0:
		_update_preview()
		return
	for p in currentPiece:
		var np := p + Vector2i(dir, 0)
		if np in currentPiece:
			continue
		if not _cell_empty(np):
			_update_preview()
			return
	for p in currentPiece:
		set_cell(p, -1)
	for i in currentPiece.size():
		currentPiece[i] = currentPiece[i] + Vector2i(dir, 0)
		var tileIndex := int(currentPieceType) + 1
		set_cell(currentPiece[i], 0, Vector2i(tileIndex, 0))
	_update_preview()

func _get_drop_distance() -> int:
	var dropDistance: int = 0
	var done := false
	for dist in boardSize.y:
		for p in currentPiece:
			var np := p + Vector2i.DOWN * dist
			if np in currentPiece:
				continue
			if not _cell_empty(np):
				dropDistance = dist - 1
				done = true
				break
		if done:
			break
	if not done:
		dropDistance = boardSize.y - 1
	return dropDistance

func _hard_drop() -> void:
	var dropDistance = _get_drop_distance()
	for p in currentPiece:
		set_cell(p, -1)
	for i in currentPiece.size():
		currentPiece[i] = currentPiece[i] + Vector2i.DOWN * dropDistance
		var tileIndex := int(currentPieceType) + 1
		set_cell(currentPiece[i], 0, Vector2i(tileIndex, 0))
	_lock_position()
@onready var lock_timer: Timer = $LockTimer

func _drop() -> void:
	if not lock_timer.is_stopped():
		return
	for p in currentPiece:
		var np := p + Vector2i.DOWN
		if np in currentPiece:
			continue
		if not _cell_empty(np):
			lock_timer.start()
			return
	for p in currentPiece:
		set_cell(p, -1)
	for i in currentPiece.size():
		currentPiece[i] = currentPiece[i] + Vector2i.DOWN
		var tileIndex := int(currentPieceType) + 1
		set_cell(currentPiece[i], 0, Vector2i(tileIndex, 0))

func _on_drop_timer_timeout() -> void:
	_drop()

func _on_lock_timer_timeout() -> void:
	_hard_drop()
