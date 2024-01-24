extends Node

var Buffs : Array[BaseWeaponEffect] = [
	BurnStatusEffect.new(),
	SlowStatusEffect.new()
]

func ResetBuffs():
	for buff in Buffs:
		buff.Level = 0
	
