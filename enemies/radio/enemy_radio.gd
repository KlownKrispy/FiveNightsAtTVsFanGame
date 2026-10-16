extends AnimatedSprite3D

@export var minMoveTime := 4.0
@export var maxMoveTime := 8.0

@export var attackTime := 20.0
@export var maxHealth := 9.0
@export var regen := 1.0
@export var damageFromFlashlight := 1.0

@onready var health := maxHealth

@onready var move_timer: Timer = $MoveTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var meow_player: AudioStreamPlayer3D = $MeowPlayer

@export var states := ["idle", "move_1", "move_2", "move_3", "lose"]
@export var currentState := "idle"
@onready var enemy_progress: ProgressBar = $EnemyProgress

@export var moveChance := 0.3

func _ready() -> void:
	move_timer.start(randf_range(minMoveTime, maxMoveTime))
	UIEvent.on_change_state.connect(_on_camera_change_state)
	UIEvent.flashlight_triggered.connect(_flashlight_triggered)

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
	if _is_on_attack_state() and UIEvent.currentCameraState == UIEvent.CameraState.LEFT:
		enemy_progress.visible = true

func _on_move_timer_timeout() -> void:
	if randf() <= moveChance:
		move()
	if currentState == "lose":
		return
	if _is_on_attack_state():
		move_timer.start(attackTime)
		meow_player.play()
		return
	move_timer.start(randf_range(minMoveTime, maxMoveTime))

func _on_camera_change_state(_oldState: UIEvent.CameraState, newState: UIEvent.CameraState):
	if not _is_on_attack_state():
		return
	enemy_progress.visible = (newState == UIEvent.CameraState.LEFT)

func _flashlight_triggered() -> void:
	if not _is_on_attack_state():
		return
	if UIEvent.currentCameraState == UIEvent.CameraState.LEFT:
		health -= damageFromFlashlight
