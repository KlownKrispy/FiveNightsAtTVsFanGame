class_name SodaButton
extends CSGBox3D

signal on_interact
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var error_noise: AudioStreamPlayer = $ErrorNoise
@onready var click_noise: AudioStreamPlayer = $ClickNoise
@export var cost: int = 1

var disabled := true

func _ready() -> void:
	set_disabled(true)
	MinigameTracker.coins_changed.connect(_coins_changed)

func _coins_changed(_amount: int, total: int) -> void:
	set_disabled(total < cost)

func set_disabled(v: bool) -> void:
	disabled = v
	if disabled:
		material.emission_energy_multiplier = 0.0
	else:
		material.emission_energy_multiplier = 0.5

func interact(_player: DayPlayer = null) -> void:
	if animation_player.is_playing():
		return
	click_noise.play()
	animation_player.play("pressed")
	if disabled:
		error_noise.play()
		return
	on_interact.emit()
	MinigameTracker.add_coins(-cost)
