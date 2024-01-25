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
var DamageIncrease : float = 0
@export var Piercing : int = 2
var OrigiginalPiercing: int = 2
@export var ReachImprovement : float = 1

var AmmoCapacity : int :
	set(value):
		if (value < 0):
			value = 0
		AmmoCapacity = min(MaxAmmoCapacity, value)
		
var ShotgunAmmoCapacity : int :
	set(value):
		if (value < 0):
			value = 0
		ShotgunAmmoCapacity = min(MaxhShotgunAmmoCapacity, value)
		
var MaxAmmoCapacity = 124
var MaxhShotgunAmmoCapacity = 30

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
