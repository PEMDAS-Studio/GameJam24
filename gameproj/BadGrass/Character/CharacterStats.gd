extends Resource
class_name CharacterStats

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
		Health = max(value, 0)
		emit_changed()
