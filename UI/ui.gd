extends Control

@onready var left_button: HoverButton = $LeftButton
@onready var right_button: HoverButton = $RightButton
@onready var down_button: HoverButton = $DownButton
@onready var up_button: HoverButton = $UpButton

var state: EventBus.CameraState = EventBus.CameraState.FORWARD
var changing: bool = false

func _ready() -> void:
	_update_buttons()
	EventBus.camera_finished_moving.connect(_on_camera_finished_moving)

func _process(_delta: float) -> void:
	if not EventBus.showUIButtons:
		if changing:
			return
		changing = true
		_update_buttons()

# TODO
func _change_state(newState: EventBus.CameraState) -> void:
	if state == newState:
		return
	if changing: # ignore while still changing state
		return
	EventBus.on_change_state.emit(state, newState)
	state = newState
	changing = true
	_update_buttons()

func _update_buttons() -> void:
	# default to invisible
	var buttonVisibility = {left_button: false, right_button: false, up_button: false, down_button: false}
	if EventBus.showUIButtons and not changing:
		match state:
			EventBus.CameraState.LEFT:
				buttonVisibility[right_button] = true
			EventBus.CameraState.RIGHT:
				buttonVisibility[left_button] = true
			EventBus.CameraState.FORWARD:
				buttonVisibility[left_button] = true
				buttonVisibility[right_button] = true
				buttonVisibility[down_button] = true
			EventBus.CameraState.CAMERAS:
				pass
			EventBus.CameraState.HIDE:
				buttonVisibility[up_button] = true
	for button in buttonVisibility:
		if buttonVisibility[button]:
			button.modulate = Color.WHITE
		else:
			button.modulate = Color.TRANSPARENT

#region Turning Helper Functions
func _try_turn_left() -> void:
	var newState: EventBus.CameraState = state
	match state:
		EventBus.CameraState.RIGHT:
			newState = EventBus.CameraState.FORWARD
		EventBus.CameraState.FORWARD:
			newState = EventBus.CameraState.LEFT
	if newState != state:
		_change_state(newState)
func _try_turn_right() -> void:
	var newState: EventBus.CameraState = state
	match state:
		EventBus.CameraState.LEFT:
			newState = EventBus.CameraState.FORWARD
		EventBus.CameraState.FORWARD:
			newState = EventBus.CameraState.RIGHT
	if newState != state:
		_change_state(newState)
func _try_turn_up() -> void:
	if state != EventBus.CameraState.HIDE:
		return
	_change_state(EventBus.CameraState.FORWARD)
func _try_turn_down() -> void:
	if state != EventBus.CameraState.FORWARD:
		return
	_change_state(EventBus.CameraState.HIDE)
#endregion

#region Button Signal Handlers
func _on_left_button_pressed() -> void:
	if changing or not EventBus.showUIButtons:
		return
	_try_turn_left()
func _on_right_button_pressed() -> void:
	if changing or not EventBus.showUIButtons:
		return
	_try_turn_right()
func _on_down_button_pressed() -> void:
	if changing or not EventBus.showUIButtons:
		return
	_try_turn_down()
func _on_up_button_pressed() -> void:
	if changing or not EventBus.showUIButtons:
		return
	_try_turn_up()
#endregion

func _on_camera_finished_moving():
	changing = false
	_update_buttons()
