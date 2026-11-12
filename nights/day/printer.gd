extends Node3D

@export var dialogues: Array[String] = [
	"It’s always nice to get a good stretch before work... my back hurts from sitting down for so long.",
	"... you better not keep me waiting, I need my ink and papers...",
]
var dialogueIndex: int = 0

func interact(_player: DayPlayer) -> void:
	if not Dialogue.is_dialogue_finished():
		return
	if not Dialogue.is_dialogue_onscreen():
		dialogueIndex = 0
	Dialogue.show("printer", dialogues[dialogueIndex])
	dialogueIndex += 1
	dialogueIndex = clampi(dialogueIndex, 0, dialogues.size() - 1)
