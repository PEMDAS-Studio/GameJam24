extends Resource
class_name EnemyStats

signal HealthChanged

@export var Health : float :
	set(value):
		var diff = Health - value
		emit_signal("HealthChanged", diff)
		Health = value
