extends Resource
class_name Base

@export var name : String
@export var Rate : float
@export var MaxCapacity : float
@export var Deposite : float :
	set(value):
		Deposite = clamp(value, 0, MaxCapacity)

@export var MaxHealth : float :
	get:
		return MaxHealth
	set(value):
		MaxHealth = value
		Health = MaxHealth

var Health : float

@export_enum("Base", "Energy Generator", "Storage", "Decontaminator")
var Type : String = "Base"

@export_multiline var Description: String

func AutomateResources(node: Node) -> void:
	return
