extends Object
class_name	RewardManager

var PossibleReward : Array[BaseWeaponEffect] = [
	BurnStatusEffect.new()
]

func _GenerateReward():
	var firstOption = PossibleReward.pick_random()
	var secondOption = PossibleReward.pick_random()
	var thirdOption = PossibleReward.pick_random()
	
	
