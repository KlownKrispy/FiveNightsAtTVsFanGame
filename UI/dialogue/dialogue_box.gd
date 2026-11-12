extends Control

@onready var character_portrait: TextureRect = $PanelContainer/PortraitPanel/CharacterPortrait
@onready var character_name: RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/CharacterName
@onready var dialogue: RichTextLabel = $PanelContainer/HBoxContainer/VBoxContainer/Dialogue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogue.on_dialogue.connect(_show_dialogue)
	Dialogue.on_hide.connect(_close)

var closable := true
func _close():
	if not closable:
		return
	dialogueOpen = false

var dialogueOpen := false

func _process(delta: float) -> void:
	var weight := 1.0 - exp(-delta * 4.0)
	if dialogueOpen:
		visible = true
		position.y = lerpf(position.y, 0.0, weight)
	else:
		position.y = lerpf(position.y, 640.0, weight)
		if position.y == 640:
			visible = false
	if Input.is_action_pressed("dialogue_skip"):
		_add_character()

@onready var audio_stream_player: AudioStreamPlayer = $NoiseOverlay/AudioStreamPlayer

func _show_dialogue(character: String, text: String) -> void:
	character_name.text = character.to_pascal_case()
	dialogue.text = text
	var img: Texture2D = portraits.get(character, portraits["unknown"])
	if img == null:
		character_name.text = "???"
	character_portrait.texture = img
	dialogueOpen = true
	if character == "the green":
		noise_overlay.visible = true
		animation_player.play("start")
		audio_stream_player.play()
		closable = false
	dialogue.visible_characters = 0
@onready var animation_player: AnimationPlayer = $NoiseOverlay/AnimationPlayer
@onready var noise_overlay: Sprite2D = $NoiseOverlay

@export var mirrorTexture: Texture2D

var portraits: Dictionary[String, Texture2D] = {
	"unknown": preload("res://UI/dialogue/character_portraits/unknown.png"),
	"the green": null,
	"computer": preload("res://UI/dialogue/character_portraits/computer.png"),
	"printer": preload("res://UI/dialogue/character_portraits/printer.png"),
	"tv": preload("res://UI/dialogue/character_portraits/tv.png"),
	"radio": preload("res://UI/dialogue/character_portraits/radio.png"),
}

@onready var talk_sound: AudioStreamPlayer = $TalkSound

func _on_audio_stream_player_finished() -> void:
	get_tree().quit()
@onready var dialogue_timer: Timer = $DialogueTimer

var pauseTicks: int = 0

func _add_character() -> void:
	if pauseTicks > 0:
		pauseTicks -= 1
		return
	if not dialogueOpen:
		return
	if dialogue.visible_ratio >= 1.0:
		Dialogue.set_dialogue_finished()
		return
	dialogue.visible_characters += charactersPerTick
	var ch := dialogue.get_parsed_text()[dialogue.visible_characters - 1]
	if ch in " \n\r\t\v'\"-_" or ch == null:
		return
	if ch in ".?!":
		pauseTicks = 6
		return
	if ch in ",()[]{}":
		pauseTicks = 3
		return
	talk_sound.play()

var charactersPerTick: int = 1
func _on_dialogue_timer_timeout() -> void:
	if Input.is_action_pressed("dialogue_skip"):
		return
	_add_character()
