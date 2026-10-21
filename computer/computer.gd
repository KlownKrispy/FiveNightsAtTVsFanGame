class_name ComputerScreen
extends Node2D
@onready var audio_listener_2d: AudioListener2D = $AudioListener2D

func show_computer():
	audio_listener_2d.make_current()

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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cursor.position += event.relative
		cursor.position.x = clampf(cursor.position.x, 0, 686)
		cursor.position.y = clampf(cursor.position.y, 0, 511)

func _on_power_button_pressed() -> void:
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

@onready var horse_tab: TextureButton = $UI/HorseTab

func _on_horse_ui_hidden() -> void:
	horse_tab.button_pressed = false
