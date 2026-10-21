class_name ComputerScreen
extends Node2D
@onready var computer_sfx_player: AudioStreamPlayer3D = $ComputerSoundOrigin/ComputerSFXPlayer
@onready var computer_click_down_sound: AudioStreamPlayer3D = $ComputerSoundOrigin/ComputerClickDownSound
@onready var computer_click_up_sound: AudioStreamPlayer3D = $ComputerSoundOrigin/ComputerClickUpSound

func _ready() -> void:
	EventBus.on_change_state.connect(_on_camera_change_state)

func show_computer():
	computer_sfx_player.stream = preload("uid://d2ipy4jchi42y")
	computer_sfx_player.play()

func hide_computer():
	EventBus.on_change_state.emit(EventBus.CameraState.CAMERAS, EventBus.CameraState.FORWARD)
	EventBus.showUIButtons = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

@onready var ui: Control = $UI
@onready var cursor: Sprite2D = $Cursor
@onready var cameras_ui: Control = $CamerasUI
@onready var games_ui: Control = $GamesUI
@onready var mail_ui: Control = $MailUI
@onready var horse_ui: Control = $HorseUI

func _play_click_down_sound() -> void:
	computer_click_down_sound.play()
func _play_click_up_sound() -> void:
	computer_click_up_sound.play()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cursor.position += event.relative
		cursor.position.x = clampf(cursor.position.x, 0, 686)
		cursor.position.y = clampf(cursor.position.y, 0, 511)
	if event is InputEventMouseButton:
		if event.button_index != MouseButton.MOUSE_BUTTON_LEFT:
			return
		if event.pressed:
			_play_click_down_sound()
		else:
			_play_click_up_sound()

func _on_power_button_pressed() -> void:
	computer_sfx_player.stream = preload("uid://bji36anch4vw4")
	computer_sfx_player.play()
	hide_computer()

func _on_cameras_tab_pressed() -> void:
	cameras_ui.visible = not cameras_ui.visible
	horse_ui.visible = false
	games_ui.visible = false
	mail_ui.visible = false

func _on_games_tab_pressed() -> void:
	games_ui.visible = not games_ui.visible
	horse_ui.visible = false
	cameras_ui.visible = false
	mail_ui.visible = false

func _on_mail_tab_pressed() -> void:
	mail_ui.visible = not mail_ui.visible
	horse_ui.visible = false
	cameras_ui.visible = false
	games_ui.visible = false

func _on_horse_tab_pressed() -> void:
	horse_ui.visible = not horse_ui.visible
	mail_ui.visible = false
	cameras_ui.visible = false
	games_ui.visible = false

@onready var cameras_tab: TextureButton = $UI/CamerasTab
@onready var games_tab: TextureButton = $UI/GamesTab
@onready var mail_tab: TextureButton = $UI/MailTab
@onready var horse_tab: TextureButton = $UI/HorseTab

func _on_horse_ui_hidden() -> void:
	horse_tab.button_pressed = false
	horse_tab.visible = false

func _on_camera_change_state(_oldState: EventBus.CameraState, newState: EventBus.CameraState) -> void:
	if newState != EventBus.CameraState.CAMERAS:
		return
	show_computer()

func _on_mail_ui_hidden() -> void:
	mail_tab.button_pressed = false

func _on_games_ui_hidden() -> void:
	games_tab.button_pressed = false

func _on_cameras_ui_hidden() -> void:
	cameras_tab.button_pressed = false
