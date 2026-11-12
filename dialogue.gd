extends Node

signal on_dialogue(charID: String, text: String)

func show(charID: String, text: String) -> void:
	_dialogueFinished = false
	_dialogueOnscreen = true
	on_dialogue.emit(charID, text)

signal on_hide

func hide() -> void:
	on_hide.emit()
	_dialogueOnscreen = false
	_dialogueFinished = true

var _dialogueFinished := true
var _dialogueOnscreen := false
func set_dialogue_finished() -> void:
	_dialogueFinished = true
func is_dialogue_finished() -> bool:
	return _dialogueFinished
func is_dialogue_onscreen() -> bool:
	return _dialogueOnscreen
