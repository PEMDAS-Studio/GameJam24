extends BaseWeaponStatusEffect
class_name BurnStatusEffect

func _init():
	Name = "Burn"
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
	
func ApplyEffect(target : BaseEnemy) -> bool:
	var chance = randf_range(1, 100)
	if  chance <= EffectDetail.ChanceOfEffect:
		Effect.TriggerEffect(target, EffectDetail)
		return true
	
	return false

func BuildDescription():
	if Level == 0:
		Description = "There is a [color=green]" + str(EffectDetail.ChanceOfEffect) + "%[/color] chance of dealing [color=green]" + str(EffectDetail.DamagePerTick) + "[/color] burn damage every [color=green]" + str(EffectDetail.Duration) + "[/color] seconds, for [color=green]" + str(EffectDetail.Duration) + " seconds" 
	else:
		var ChanceEffectText = str(EffectDetail.ChanceOfEffect) + " -> " + str(EffectLevels[Level].ChanceOfEffect) if EffectDetail.ChanceOfEffect != EffectLevels[Level].ChanceOfEffect else str(EffectDetail.ChanceOfEffect)
		var DamagePerTickText = str(EffectDetail.DamagePerTick) + " -> " + str(EffectLevels[Level].DamagePerTick) if EffectDetail.DamagePerTick != EffectLevels[Level].DamagePerTick else str(EffectDetail.DamagePerTick)
		var TickRateText = str(EffectDetail.TickRate) + " -> " + str(EffectLevels[Level].TickRate) if EffectDetail.TickRate != EffectLevels[Level].TickRate else str(EffectDetail.TickRate)
		var DurationText = str(EffectDetail.Duration) + " -> " + str(EffectLevels[Level].Duration) if EffectDetail.Duration != EffectLevels[Level].Duration else str(EffectDetail.Duration)
		Description = "There is a [color=green]" + ChanceEffectText + " %[/color] chance of dealing [color=green]" + DamagePerTickText +  "[/color] burn damage every [color=green]" + TickRateText +  "[/color] seconds, for [color=green]" + DurationText +  "[/color] seconds" 		
