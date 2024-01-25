extends BaseWeaponStatEffect
class_name DamageStatusEffect

func _init():
	Name = "Fear"
	EffectLevels = [
		DamageStatusDetails.new().Init(7),
		DamageStatusDetails.new().Init(12.5),
		DamageStatusDetails.new().Init(18),
		DamageStatusDetails.new().Init(25)
	]
	EffectDetail = EffectLevels[0]
	
func ApplyEffect(target : Character) -> bool:
	target.Stats.DamageIncrease = EffectDetail.Damage
	return true

func BuildDescription():
	if Level == 0:
		Description = "Increase the player attack by [color=green]" + str(EffectDetail.Damage) + "[/color]"
	else:
		var PiercingEffectText = str(EffectDetail.Damage) + " -> " + str(EffectLevels[Level].Damage) if EffectDetail.Damage != EffectLevels[Level].Damage else str(EffectDetail.Damage)
		Description = "Increase the player attack by [color=green]" + PiercingEffectText + "[/color]"
