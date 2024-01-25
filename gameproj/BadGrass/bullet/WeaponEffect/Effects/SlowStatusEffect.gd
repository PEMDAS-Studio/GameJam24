extends BaseWeaponStatusEffect
class_name SlowStatusEffect

func _init():
	Name = "Slow"
	EffectLevels = [
		SlowStatusDetails.new().Init(3, 16, 20),
		SlowStatusDetails.new().Init(3.5, 16, 21.5),
		SlowStatusDetails.new().Init(3.5, 20, 22),
		SlowStatusDetails.new().Init(4, 20, 25),
		SlowStatusDetails.new().Init(4, 25, 25),
		SlowStatusDetails.new().Init(4, 30, 28),
	]
	EffectDetail = EffectLevels[0]
	Effect = SlowEffect.new()
	
func ApplyEffect(target : BaseEnemy) -> bool:
	var chance = randf_range(1, 100)
	if  chance <= EffectDetail.ChanceOfEffect:
		Effect.TriggerEffect(target, EffectDetail)
		return true
	
	return false

func BuildDescription():
	if Level == 0:
		Description = "There is a [color=green]" + str(EffectDetail.ChanceOfEffect) + "%[/color] chance of slowing the enemy by [color=green]" + str(EffectDetail.SlowPercentage) + "[/color] for [color=green]" + str(EffectDetail.Duration) + " seconds" 
	else:
		var ChanceEffectText = str(EffectDetail.ChanceOfEffect) + " -> " + str(EffectLevels[Level].ChanceOfEffect) if EffectDetail.ChanceOfEffect != EffectLevels[Level].ChanceOfEffect else str(EffectDetail.ChanceOfEffect)
		var SlowPercentageText = str(EffectDetail.SlowPercentage) + " -> " + str(EffectLevels[Level].SlowPercentage) if EffectDetail.SlowPercentage != EffectLevels[Level].SlowPercentage else str(EffectDetail.SlowPercentage)
		var DurationText = str(EffectDetail.Duration) + " -> " + str(EffectLevels[Level].Duration) if EffectDetail.Duration != EffectLevels[Level].Duration else str(EffectDetail.Duration)
		Description = "There is a [color=green]" + ChanceEffectText + " %[/color] chance of slowing the enemy by [color=green]" + SlowPercentageText +  "[/color] for [color=green]" + DurationText +  "[/color] seconds" 		
