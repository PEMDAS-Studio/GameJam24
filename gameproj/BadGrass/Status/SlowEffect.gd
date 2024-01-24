extends StatusEffect
class_name SlowEffect

func TriggerEffect(target, effectDetails : SlowStatusDetails):
	var SlowTimer = Timer.new()
	SlowTimer.one_shot = true
	SlowTimer.wait_time = effectDetails.Duration
	SlowTimer.timeout.connect(_RemoveTick.bind(target, SlowTimer))
	target.Stats.Speed -= target.Stats.Speed * effectDetails.SlowPercentage / 100
	target.add_child(SlowTimer)
	SlowTimer.start()
	
func _RemoveTick(target, timer: Timer):
	target.Stats.Speed = target.Stats.OriginalSpeed
	timer.queue_free()
