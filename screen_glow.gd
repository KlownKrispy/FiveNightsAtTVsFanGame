extends Sprite3D

func _ready() -> void:
	CameraRegistry.monitor = self
