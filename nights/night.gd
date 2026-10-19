extends Node

var _debugNight: NightConfig = preload("uid://jh2ryc63wusi")
var _currentNight := _debugNight

func get_current_night() -> NightConfig:
	return _currentNight

signal night_changed
