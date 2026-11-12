class_name DialogueNPC
extends Node3D

@export var dialogues: Array[String] = [
	"Placeholder"
]
var dialogueIndex: int = 0
@export var npcName := "the green"

func interact(_player: DayPlayer) -> void:
	if not Dialogue.is_dialogue_finished():
		return
	if not Dialogue.is_dialogue_onscreen():
		dialogueIndex = 0
	Dialogue.show(npcName, dialogues[dialogueIndex])
	dialogueIndex += 1
	dialogueIndex = clampi(dialogueIndex, 0, dialogues.size() - 1)
