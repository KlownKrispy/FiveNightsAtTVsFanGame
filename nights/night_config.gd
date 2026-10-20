class_name NightConfig
extends Resource

#region Time
## Number of minutes since 12AM, negative should work
@export var nightTimeStart: int = 0
## Number of minutes the night lasts normally
@export var nightLength: int = 60 * 6
## Number of minutes of overtime maximum
@export var maxOvertime: int = 60 * 2
#endregion Time

#region Radio
@export_category("Radio")
@export var radioMoveChance := 0.3
@export var radioMinMoveTime := 4.0
@export var radioMaxMoveTime := 8.0
@export var radioAttackTime := 10.0
@export var radioMaxHealth := 9.0
@export var radioRegen := 1.0
@export var radioDamageFromFlashlight := 1.0
#endregion Radio

#region TV
@export_category("TV")
@export var tvMinMoveTime := 5.0
@export var tvMaxMoveTime := 5.0
@export var tvAttackTime := 10.0
@export var tvHideTime := 2.0
@export var tvMoveChance := 0.35
#endregion TV

#region Computer
@export_category("Computer")
@export var computerMaxWindSeconds: float = 30.0
@export var computerInitialWindAmount: float = 30.0
@export var computerWindGracePeriod: float = 5.0
@export var computerWindPerSecond: float = 5.0
#endregion Computer

#region Printer
@export_category("Printer")
## Maximum amount of errors Printer can have this night
@export var printerMaxErrors: int = 5
## For each printerIdleConversion minutes printer is idle, add 1 minute to the night duration, up to overtime
@export var printerIdleConversion: int = 2
## If Printer is idle for over this number of minutes, start increasing overtime
@export var printerMinimumIdleForOvertime: int = 60
## Amount of variation in Printer's time between errors; in units of (nightLength+maxOvertime) / (maxErrors+1)
## In other words, default settings mean she can get errors every:
## (0.7 * 8 hours / 6) to (1.3 * 8 hours / 6)
## Or, one error every 56 to 104 minutes
@export var printerErrorTimeVariation: float = 0.3
var printerMinimumErrorTime: float:
	get:
		return (1.0 - printerErrorTimeVariation) * (nightLength + maxOvertime) / (printerMaxErrors + 1.0)
var printerMaximumErrorTime: float:
	get:
		return (1.0 + printerErrorTimeVariation) * (nightLength + maxOvertime) / (printerMaxErrors + 1.0)
#endregion
