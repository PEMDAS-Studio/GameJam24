extends Base
class_name ElectricalBase

@export var DischargeRate : float
var isDischarging : bool = false

func AutomateResources(node : Node) -> void:
	# COnfigure the charge Rate.
	var rechargetimer = Timer.new()
	rechargetimer.one_shot = false
	node.add_child(rechargetimer)
	rechargetimer.wait_time = 0.5
	rechargetimer.timeout.connect(NaturalRecharge)
	rechargetimer.start()
	
func NaturalRecharge():
	Deposite += Rate
