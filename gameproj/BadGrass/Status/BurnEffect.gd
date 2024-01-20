extends StatusEffect
class_name BurnEffect

func TriggerEffect(target, effectDetails : BurnStatusDetails):
	var burnTimer = Timer.new()
	burnTimer.one_shot = true
	burnTimer.wait_time = effectDetails.Duration
	burnTimer.timeout.connect(_RemoveTick.bind(burnTimer))
	
	var tickTimer = Timer.new()
	tickTimer.one_shot = false
	tickTimer.wait_time = effectDetails.TickRate
	tickTimer.timeout.connect(_AddBurn.bind(target, effectDetails))
	burnTimer.add_child(tickTimer)
	target.add_child(burnTimer)
	
	burnTimer.start()
	tickTimer.start()
	
func _AddBurn(target, effectDetails : BurnStatusDetails):
	#target.Stats.Health -= effectDetails.DamagePerTick
	target.health -= effectDetails.DamagePerTick
	
func _RemoveTick(timer: Timer):
	timer.queue_free()
