extends Panel

func _ready() -> void:
	MinigameTracker.coins_changed.connect(_coins_changed)

@onready var label: Label = $Label

func _coins_changed(_amount: int, total: int):
	label.text = str(total)
