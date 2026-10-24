extends TileMapLayer

@export var bagSize: int = 2

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

@export var boardSize := Vector2i(10, 20)

func _ready():
	_init_bag()
	_setup_board()
	if not is_visible_in_tree():
		_pause()

func _setup_board() -> void:
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

func _generate_new_piece() -> void:
	var tileIndex: int = 1 + int(currentPieceType)
	@warning_ignore("integer_division")
	var topMid: Vector2i = Vector2i(int(boardSize.x / 2), 0)
	match currentPieceType:
		Piece.LINE:
			currentPiece = [
				topMid + Vector2i.LEFT,
				topMid,
				topMid + Vector2i.RIGHT,
				topMid + Vector2i.RIGHT * 2
			]
		Piece.J:
			currentPiece = [
				topMid + Vector2i.LEFT,
				topMid + Vector2i(-1, 1),
				topMid + Vector2i.DOWN,
				topMid + Vector2i(1,  1)
			]
		Piece.S:
			currentPiece = [
				topMid + Vector2i.LEFT,
				topMid,
				topMid + Vector2i.DOWN,
				topMid + Vector2i(1, 1)
			]
		Piece.L:
			currentPiece = [
				topMid + Vector2i.RIGHT,
				topMid + Vector2i(-1, 1),
				topMid + Vector2i.DOWN,
				topMid + Vector2i(1, 1)
			]
		Piece.Z:
			currentPiece = [
				topMid + Vector2i.RIGHT,
				topMid,
				topMid + Vector2i.DOWN,
				topMid + Vector2i(-1, 1)
			]
		Piece.SQUARE:
			currentPiece = [
				topMid + Vector2i.RIGHT,
				topMid,
				topMid + Vector2i.DOWN,
				topMid + Vector2i(1, 1)
			]
		Piece.T:
			currentPiece = [
				topMid,
				topMid + Vector2i(-1, 1),
				topMid + Vector2i.DOWN,
				topMid + Vector2i( 1, 1)
			]
	for pos in currentPiece:
		if get_cell_atlas_coords(pos) != Vector2i(-1, -1):
			_lose()
		set_cell(pos, 0, Vector2i(tileIndex, 0))

var moveTimer := 0.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("tetris_hard_drop"):
		_hard_drop()
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

func _lose() -> void:
	pass

func _take_piece() -> void:
	currentPieceType = bag.pop_front()
	_generate_new_piece()
	_try_replenish_bag()

func _try_replenish_bag():
	var bagMaxSize = bagSize * 7
	if bagMaxSize - bag.size() == 7:
		var newPieces := Piece.values()
		newPieces.shuffle()
		bag += newPieces

func _init_bag():
	if not bag.is_empty():
		return
	var pieceSet = Piece.values()
	for i in bagSize:
		bag += pieceSet
	bag.shuffle()
	_take_piece()

func _on_visibility_changed() -> void:
	if not is_visible_in_tree():
		_pause()
	else:
		_unpause()

func _unpause() -> void:
	pass

func _pause() -> void:
	print("Paused")

func _lock_position() -> void:
	_take_piece()

func _try_move(dir: int) -> void:
	if dir == 0:
		return
	for p in currentPiece:
		var np := p + Vector2i(dir, 0)
		if np in currentPiece:
			continue
		if get_cell_source_id(np) != -1 or np.x < 0 or np.x >= boardSize.x:
			return
	for p in currentPiece:
		set_cell(p, -1)
	for i in currentPiece.size():
		currentPiece[i] = currentPiece[i] + Vector2i(dir, 0)
		var tileIndex := int(currentPieceType) + 1
		set_cell(currentPiece[i], 0, Vector2i(tileIndex, 0))

func _hard_drop() -> void:
	var dropDistance: int = 0
	var done := false
	for dist in boardSize.y:
		for p in currentPiece:
			var np := p + Vector2i.DOWN * dist
			if np in currentPiece:
				continue
			if get_cell_source_id(np) != -1 or np.y >= boardSize.y:
				dropDistance = dist - 1
				done = true
				break
		if done:
			break
	for p in currentPiece:
		set_cell(p, -1)
	for i in currentPiece.size():
		currentPiece[i] = currentPiece[i] + Vector2i.DOWN * dropDistance
		var tileIndex := int(currentPieceType) + 1
		set_cell(currentPiece[i], 0, Vector2i(tileIndex, 0))
	_lock_position()

func _drop() -> void:
	for p in currentPiece:
		var np := p + Vector2i.DOWN
		if np in currentPiece:
			continue
		if get_cell_source_id(np) != -1 or np.y >= boardSize.y:
			_lock_position()
			return
	for p in currentPiece:
		set_cell(p, -1)
	for i in currentPiece.size():
		currentPiece[i] = currentPiece[i] + Vector2i.DOWN
		var tileIndex := int(currentPieceType) + 1
		set_cell(currentPiece[i], 0, Vector2i(tileIndex, 0))

func _on_drop_timer_timeout() -> void:
	_drop()
