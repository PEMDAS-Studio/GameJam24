extends BaseWeaponStatusEffect
class_name FearStatusEffect

func _init():
	Name = "Fear"
	EffectLevels = [
		FearStatusDetails.new().Init(2, 4),
		FearStatusDetails.new().Init(2, 10),
		FearStatusDetails.new().Init(2, 16),
		FearStatusDetails.new().Init(3, 20),
		FearStatusDetails.new().Init(3, 30),
		FearStatusDetails.new().Init(4.5, 38),
	]
	EffectDetail = EffectLevels[0]
	Effect = FearEffect.new()
	
func ApplyEffect(target : Enemy) -> bool:
	var chance = randf_range(1, 100)
	if  chance <= EffectDetail.ChanceOfEffect:
		Effect.TriggerEffect(target, EffectDetail)
		return true
	
	return false

func BuildDescription():
	if Level == 0:
		Description = "There is a [color=green]" + str(EffectDetail.ChanceOfEffect) + "%[/color] chance of applying fear to the enemy for [color=green]" + str(EffectDetail.Duration) + " seconds" 
	else:
		var ChanceEffectText = str(EffectDetail.ChanceOfEffect) + " -> " + str(EffectLevels[Level].ChanceOfEffect) if EffectDetail.ChanceOfEffect != EffectLevels[Level].ChanceOfEffect else str(EffectDetail.ChanceOfEffect)
		var DurationText = str(EffectDetail.Duration) + " -> " + str(EffectLevels[Level].Duration) if EffectDetail.Duration != EffectLevels[Level].Duration else str(EffectDetail.Duration)
		Description = "There is a [color=green]" + ChanceEffectText + " %[/color] chance of applying fear to the enemy for [color=green]" + DurationText +  "[/color] seconds" 		
