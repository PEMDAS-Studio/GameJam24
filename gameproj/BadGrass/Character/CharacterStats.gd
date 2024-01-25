extends Resource
class_name CharacterStats

signal HealthChanger
signal Died

@export var DashSpeed : int
@export var DashDuration : float
@export var DashChargeRate : float
@export var DashCharge : int :
	set(value):
		DashCharge = value
		emit_changed()

@export var RegenRate : float
@export var BaseRegenAmount : int

@export var OriginalSpeed : int:
	set(value):
		Speed = value
		OriginalSpeed = value

@export var OriginalHeath : float:
	set(value):
		MaxHealth = value
		OriginalHeath = value

@export var Strength : float = 10
@export var Piercing : int = 2
@export var ReachImprovement : float = 1

var Speed : int :
	set(value):
		Speed = max(value, 0)

var MaxHealth : float :
	get:
		return MaxHealth
	set(value):
		MaxHealth = value
		if (Health > value):
			Health = value
		emit_changed()

var Health : float :
	set(value):
		emit_signal("HealthChanger", Health - value)
		Health = max(value, 0)
		emit_changed()
		if (Health == 0):
			emit_signal("Died")
			
var MaxBeaconCount : int = 3
var BeaconCount : int = 1 :
	set(value):
		BeaconCount = min(value, MaxBeaconCount)
		emit_changed()
		
var MaxTurretCount : int = 2
var TurretCount : int = 1 :
	set(value):
		TurretCount = min(value, MaxTurretCount)
		emit_changed()
