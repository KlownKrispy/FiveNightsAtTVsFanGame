class_name NightConfig
extends Resource

#region Time
@export_group("Time")
## Number of minutes since 12AM, negative should work
@export var nightTimeStart: int = 0
## Number of minutes the night lasts normally
@export var nightLength: int = 60 * 6
## Number of minutes of overtime maximum
@export var maxOvertime: int = 60 * 2
#endregion Time

#region Radio
@export_group("Radio", "radio")
@export var radioActive: bool = true
@export_subgroup("Worktime", "radioWorktime")
@export var radioWorktimeMoveChance := 0.3
@export var radioWorktimeMinMoveTime := 12.0
@export var radioWorktimeMaxMoveTime := 16.0
@export_subgroup("Overtime", "radioOvertime")
@export var radioOvertimeMoveChance := 0.45
@export var radioOvertimeMinMoveTime := 8.0
@export var radioOvertimeMaxMoveTime := 12.0
@export_subgroup("")
@export var radioAttackTime := 10.0
@export var radioMaxHealth := 9.0
@export var radioRegen := 1.0
@export var radioDamageFromFlashlight := 1.0
var radioMinMoveTime: float:
	get:
		if Night.is_in_overtime():
			return radioOvertimeMinMoveTime
		return radioWorktimeMinMoveTime
var radioMaxMoveTime: float:
	get:
		if Night.is_in_overtime():
			return radioOvertimeMaxMoveTime
		return radioWorktimeMaxMoveTime
var radioMoveChance: float:
	get:
		if Night.is_in_overtime():
			return radioOvertimeMoveChance
		return radioWorktimeMoveChance
#endregion Radio

#region TV
@export_group("TV", "tv")
@export var tvActive: bool = true
@export_subgroup("Worktime", "tvWorktime")
@export var tvWorktimeMoveChance := 0.35
@export var tvWorktimeMinMoveTime := 10.0
@export var tvWorktimeMaxMoveTime := 10.0
@export_subgroup("Overtime", "tvOvertime")
@export var tvOvertimeMoveChance := 0.5
@export var tvOvertimeMinMoveTime := 7.5
@export var tvOvertimeMaxMoveTime := 7.5
@export_subgroup("")
@export var tvAttackTime := 10.0
@export var tvHideTime := 2.0
var tvMinMoveTime: float:
	get:
		if Night.is_in_overtime():
			return tvOvertimeMinMoveTime
		return tvWorktimeMinMoveTime
var tvMaxMoveTime: float:
	get:
		if Night.is_in_overtime():
			return tvOvertimeMaxMoveTime
		return tvWorktimeMaxMoveTime
var tvMoveChance: float:
	get:
		if Night.is_in_overtime():
			return tvOvertimeMoveChance
		return tvWorktimeMoveChance
#endregion TV

#region Computer
@export_group("Computer", "computer")
@export var computerActive: bool = true
@export var computerMaxWindSeconds: float = 30.0
@export var computerInitialWindAmount: float = 30.0
@export var computerWindGracePeriod: float = 5.0
@export var computerWindPerSecond: float = 5.0
#endregion Computer

#region Printer
@export_group("Printer", "printer")
@export var printerActive: bool = true
## Maximum amount of errors Printer can have this night
@export var printerMaxErrors: int = 5
@export var printerWorkload: int = 4 * 60
## Amount of variation in Printer's time between errors; in units of (nightLength+maxOvertime) / (maxErrors+1)
## In other words, default settings mean she can get errors every:
## (0.7 * 8 hours / 6) to (1.3 * 8 hours / 6)
## Or, one error every 56 to 104 minutes
@export var printerErrorTimeVariation: float = 0.3
var printerMinimumErrorTime: float:
	get:
		if not printerActive:
			return nightLength + maxOvertime
		return (1.0 - printerErrorTimeVariation) * (nightLength + maxOvertime) / (printerMaxErrors + 1.0)
var printerMaximumErrorTime: float:
	get:
		if not printerActive:
			return nightLength + maxOvertime
		return (1.0 + printerErrorTimeVariation) * (nightLength + maxOvertime) / (printerMaxErrors + 1.0)
#endregion
