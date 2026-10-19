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
#endregion
