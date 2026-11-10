extends Node

signal on_dialogue(charID: String, text: String)

func show(charID: String, text: String) -> void:
	on_dialogue.emit(charID, text)

signal on_hide

func hide() -> void:
	on_hide.emit()
