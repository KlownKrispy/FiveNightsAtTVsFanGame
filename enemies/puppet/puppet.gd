extends Node3D
@onready var sprite_3d: Sprite3D = $Sprite3D

func _ready() -> void:
	EventBus.wind_attack.connect(_attack)
func _attack() -> void:
	EventBus.forceCameraForward = true
	EventBus.showUIButtons = false
	sprite_3d.visible = true
