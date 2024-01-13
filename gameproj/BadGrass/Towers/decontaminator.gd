extends Node2D

@export var Stats : Base

# Called when the node enters the scene tree for the first time.
func _ready():
	Stats.AutomateResources(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print_debug(Stats.Deposite)
	print_debug(Stats.DischargeRate)
