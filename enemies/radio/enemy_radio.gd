extends AnimatedSprite3D

var minMoveTime: float:
	get: return Night.get_current_night().radioMinMoveTime
var maxMoveTime: float:
	get: return Night.get_current_night().radioMaxMoveTime
var moveChance: float:
	get: return Night.get_current_night().radioMoveChance
var attackTime: float:
	get: return Night.get_current_night().radioAttackTime
var maxHealth: float:
	get: return Night.get_current_night().radioMaxHealth
var regen: float:
	get: return Night.get_current_night().radioRegen
var damageFromFlashlight: float:
	get: return Night.get_current_night().radioDamageFromFlashlight

@onready var health := maxHealth

@onready var move_timer: Timer = $MoveTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var lose_sound_player: AudioStreamPlayer = $LoseSoundPlayer
@onready var attack_cue_player: AudioStreamPlayer = $AttackCuePlayer

@export var states := ["idle", "move_1", "move_2", "move_3", "lose"]
@export var currentState := "idle"
@onready var enemy_progress: ProgressBar = $EnemyProgress

func _ready() -> void:
	move_timer.start(randf_range(minMoveTime, maxMoveTime))
	EventBus.on_change_state.connect(_on_camera_change_state)
	EventBus.flashlight_triggered.connect(_flashlight_triggered)

func _process(delta: float) -> void:
	if not _is_on_attack_state():
		return
	if health <= 0.0:
		currentState = "idle"
		animation_player.play(currentState)
		move_timer.start(randf_range(minMoveTime, maxMoveTime))
		enemy_progress.visible = false
		health = maxHealth
		return
	health = clampf(health + regen * delta, 0, maxHealth)
	enemy_progress.max_value = maxHealth
	enemy_progress.value = health

func _is_on_attack_state() -> bool:
	return (currentState != "lose" and _next_state() == "lose")

func _next_state() -> String:
	var idx = states.find(currentState)
	idx += 1
	idx = clampi(idx, 0, len(states) - 1)
	return states[idx]

func _emit_move_signal(oldState: String, newState: String) -> void:
	var oldCamIDs: Array[String] = []
	var newCamIDs: Array[String] = []
	match oldState:
		"idle", "move_1", "move_2", "move_3":
			oldCamIDs = ["CubicleCamera"]
		"lose":
			pass
	match newState:
		"idle", "move_1", "move_2", "move_3":
			newCamIDs = ["CubicleCamera"]
		"lose":
			pass
	EventBus.radio_moved.emit(oldCamIDs, newCamIDs)

func move() -> void:
	if currentState == "lose":
		return
	var idx = states.find(currentState)
	idx += 1
	idx = clampi(idx, 0, len(states) - 1)
	_emit_move_signal(currentState, states[idx])
	currentState = states[idx]
	animation_player.play(currentState)
	if currentState == "lose":
		EventBus.showUIButtons = false
		EventBus.forceCameraForward = true
		lose_sound_player.play()
	if _is_on_attack_state() and EventBus.currentCameraState == EventBus.CameraState.LEFT:
		enemy_progress.visible = true

func _on_move_timer_timeout() -> void:
	if randf() <= moveChance:
		move()
	if currentState == "lose":
		return
	if _is_on_attack_state():
		move_timer.start(attackTime)
		attack_cue_player.play()
		return
	move_timer.start(randf_range(minMoveTime, maxMoveTime))

func _on_camera_change_state(_oldState: EventBus.CameraState, newState: EventBus.CameraState):
	if not _is_on_attack_state():
		return
	enemy_progress.visible = (newState == EventBus.CameraState.LEFT)

func _flashlight_triggered() -> void:
	if not _is_on_attack_state():
		return
	if EventBus.currentCameraState == EventBus.CameraState.LEFT:
		health -= damageFromFlashlight
