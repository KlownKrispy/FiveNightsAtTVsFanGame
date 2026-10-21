extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Night.minute_passed.connect(_minute_passed)

func _minute_passed() -> void:
	var hour := Night.get_clock_hour()
	var minute := Night.get_clock_minute()
	var suffix = "AM"
	if hour >= 12:
		suffix = "PM"
	var adjHour = hour % 12
	if adjHour == 0:
		adjHour = 12
	text = "%02d:%02d %s" % [adjHour, minute, suffix]
	var elapsed := Night.get_current_time() - Night.get_current_night().nightTimeStart
	if elapsed >= Night.get_current_night().nightLength:
		# overtime!
		add_theme_color_override("font_color", Color.DARK_RED)
