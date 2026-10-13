extends Node3D
@onready var sprite_3d: Sprite3D = $Sprite3D

func _ready() -> void:
	UIEvent.wind_attack.connect(_attack)
func _attack() -> void:
	UIEvent.forceCameraForward = true
	UIEvent.showUIButtons = false
	sprite_3d.visible = true
