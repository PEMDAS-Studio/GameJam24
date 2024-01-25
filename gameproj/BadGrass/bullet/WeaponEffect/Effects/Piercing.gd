extends BaseWeaponStatEffect
class_name PiercingStatusEffect

func _init():
	Name = "Fear"
	EffectLevels = [
		PiercingStatusDetails.new().Init(1),
		PiercingStatusDetails.new().Init(2),
		PiercingStatusDetails.new().Init(3),
	]
	EffectDetail = EffectLevels[0]
	
func ApplyEffect(target : Character) -> bool:
	target.Stats.Piercing = EffectDetail.Piercing + target.Stats.OrigiginalPiercing
	return true

func BuildDescription():
	if Level == 0:
		Description = "Increase the nunber of enemy a bullet can pierce by [color=green]" + str(EffectDetail.Piercing)  + "[/color]"
	else:
		var PiercingEffectText = str(EffectDetail.Piercing) + " -> " + str(EffectLevels[Level].Piercing) if EffectDetail.Piercing != EffectLevels[Level].Piercing else str(EffectDetail.Piercing)
		Description = "Increase the nunber of enemy a bullet can pierce by [color=green]" + PiercingEffectText + "[/color]"
