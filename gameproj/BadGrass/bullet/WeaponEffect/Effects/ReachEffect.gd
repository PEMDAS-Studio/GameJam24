extends BaseWeaponStatEffect
class_name ReachStatusEffect

func _init():
	Name = "Fear"
	EffectLevels = [
		ReachStatusDetails.new().Init(1.10),
		ReachStatusDetails.new().Init(1.155),
		ReachStatusDetails.new().Init(1.25),
		ReachStatusDetails.new().Init(1.37)
	]
	EffectDetail = EffectLevels[0]
	
func ApplyEffect(target : Character) -> bool:
	target.Stats.ReachImprovement = EffectDetail.Reach
	return true

func BuildDescription():
	if Level == 0:
		Description = "Increase the player attack reach by [color=green]" + str((EffectDetail.Reach - 1) * 100) + "[/color]%"
	else:
		var PiercingEffectText = str((EffectDetail.Reach - 1) * 100) + " -> " + str((EffectLevels[Level].Reach - 1) * 100) if EffectDetail.Reach != EffectLevels[Level].Reach else str((EffectDetail.Reach - 1) * 100)
		Description = "Increase the player attack reach by [color=green]" + PiercingEffectText + "[/color]%"
