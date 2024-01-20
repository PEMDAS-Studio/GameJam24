extends BaseWeaponStatusEffect
class_name BurnStatusEffect

var EffectLevels : Array[BurnStatusDetails]
var EffectDetail : BurnStatusDetails 
var Level : int

func _init():
	EffectLevels = [
		BurnStatusDetails.new().Init(3, 1 ,9 ,0.75),
		BurnStatusDetails.new().Init(3.5, 1 ,9 ,0.75),
		BurnStatusDetails.new().Init(3.5, 0.9 ,9 ,0.75),
		BurnStatusDetails.new().Init(4, 0.9 ,15 ,0.75),
		BurnStatusDetails.new().Init(4, 0.9 ,15 ,1),
		BurnStatusDetails.new().Init(4, 0.75 ,25 ,1.3),
	]
	EffectDetail = EffectLevels[0]
	Effect = BurnEffect.new()
	
func ApplyEffect(target : Enemy) -> bool:
	var chance = randf_range(1, 100)
	if chance <= EffectDetail.ChanceOfEffect:
		Effect.TriggerEffect(target, EffectDetail)
		return true
	
	return false
