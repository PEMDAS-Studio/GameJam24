extends Node

var Buffs : Array[BaseWeaponEffect] = [
	BurnStatusEffect.new(),
	SlowStatusEffect.new(),
	FearStatusEffect.new(),
	PiercingStatusEffect.new(),
	ReachStatusEffect.new(),
	DamageStatusEffect.new()
]

func ResetBuffs():
	for buff in Buffs:
		buff.Level = 0
	
