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
		Health = value
		OriginalHeath = value

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
