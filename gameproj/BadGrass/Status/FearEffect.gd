extends StatusEffect
class_name FearEffect

func TriggerEffect(target, effectDetails : FearStatusDetails):
	var fearTimer = Timer.new()
	fearTimer.one_shot = true
	fearTimer.wait_time = effectDetails.Duration
	fearTimer.timeout.connect(_RemoveTick.bind(fearTimer, target))
	target.Stats.Speed = -40
	fearTimer.start()
	
func _RemoveTick(timer: Timer, target):
	target.Stats.Speed = target.Stats.OriginalSpeed
	timer.queue_free()
