extends AnimatedSprite3D

var minMoveTime: float:
	get: return Night.get_current_night().tvMinMoveTime
var maxMoveTime: float:
	get: return Night.get_current_night().tvMaxMoveTime
var attackTime: float:
	get: return Night.get_current_night().tvAttackTime
var hideTime: float:
	get: return Night.get_current_night().tvHideTime
var moveChance: float:
	get: return Night.get_current_night().tvMoveChance

@onready var hideTimeRemaining := hideTime

@onready var move_timer: Timer = $MoveTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var walk_sound: AudioStreamPlayer3D = $WalkSound
@onready var meow_player: AudioStreamPlayer3D = $MeowPlayer

@export var states := ["idle", "move_1", "move_2", "move_3", "move_4", "lose"]
@export var currentState := "idle"

var _leaveState := "leaving"

var _playerIsHiding := false
var _readyToAttack := false
@onready var debug_bar_attack: ProgressBar = $DebugBarAttack
@onready var debug_bar_hide: ProgressBar = $DebugBarHide

func _ready() -> void:
	move_timer.start(randf_range(minMoveTime, maxMoveTime))
	UIEvent.on_change_state.connect(_on_camera_change_state)

func _process(delta: float) -> void:
	if not _is_on_attack_state():
		return
	if _playerIsHiding:
		hideTimeRemaining -= delta
	if UIEvent.IS_DEBUG_MODE:
		debug_bar_attack.visible = true
		debug_bar_attack.value = move_timer.time_left
		debug_bar_attack.max_value = move_timer.wait_time
		debug_bar_hide.visible = true
		debug_bar_hide.max_value = hideTime
		debug_bar_hide.value = hideTime - hideTimeRemaining
	if hideTimeRemaining <= 0.0:
		currentState = "idle"
		animation_player.play("leaving")
		walk_sound.pitch_scale = 0.8 + 0.4 * randf()
		walk_sound.play()
		move_timer.start(randf_range(minMoveTime, maxMoveTime))
		hideTimeRemaining = hideTime
		debug_bar_attack.visible = false
		debug_bar_hide.visible = false
		_readyToAttack = false
		return

func _is_on_attack_state() -> bool:
	return (currentState != "lose" and _next_state() == "lose")

func _next_state() -> String:
	var idx = states.find(currentState)
	idx += 1
	idx = clampi(idx, 0, len(states) - 1)
	return states[idx]

func move() -> void:
	if currentState == "lose":
		return
	var idx = states.find(currentState)
	idx += 1
	idx = clampi(idx, 0, len(states) - 1)
	currentState = states[idx]
	animation_player.play(currentState)
	if currentState == "lose":
		UIEvent.showUIButtons = false
		UIEvent.forceCameraForward = true
		audio_stream_player_3d.play()

func _on_move_timer_timeout() -> void:
	if _playerIsHiding and _is_on_attack_state():
		_readyToAttack = true
		move_timer.stop()
		return
	if randf() <= moveChance:
		move()
		var soundEmissionStates = ["move_2", "move_3", "move_4"]
		if currentState in soundEmissionStates:
			walk_sound.pitch_scale = 0.8 + 0.4 * randf()
			walk_sound.play()
	if currentState == "lose":
		return
	if _is_on_attack_state():
		move_timer.start(attackTime)
		meow_player.play()
		return
	move_timer.start(randf_range(minMoveTime, maxMoveTime))

func _on_camera_change_state(_oldState: UIEvent.CameraState, newState: UIEvent.CameraState):
	_playerIsHiding = (newState == UIEvent.CameraState.HIDE)
	if not _is_on_attack_state():
		return
	if not _playerIsHiding and _readyToAttack:
		move()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == _leaveState:
		animation_player.play(currentState)
