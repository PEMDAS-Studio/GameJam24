extends Node

var _Items : Array[Resource] = [
	load("res://BadGrass/Items/Cookie.tscn"),
	load("res://BadGrass/Items/RegenPotionThree.tscn"),
	load("res://BadGrass/Items/Fish.tscn"),
	load("res://BadGrass/Items/SpeedBoostTwo.tscn"),
	load("res://BadGrass/Items/RegenPotionTwo.tscn"),
	load("res://BadGrass/Items/CandieStick.tscn"),
	load("res://BadGrass/Items/RegenPotionOne.tscn"),
	load("res://BadGrass/Items/CandieBall.tscn"),
	load("res://BadGrass/Items/SpeedBoostOne.tscn"),
	load("res://BadGrass/Items/Banana.tscn"),
	load("res://BadGrass/Items/Apple.tscn"),
]

var _ItemDropRates : Array[int] = [2, 3, 9, 15, 15, 22, 30, 40, 65, 65, 70] 

func GetItem() -> BaseItem:
	var totalPercentage = _ItemDropRates.reduce(func(accum, number): return accum + number)
	var percentage = randi_range(1, totalPercentage)
	var item
	var prevChance = 0
	for index in _ItemDropRates.size():
		var chance = _ItemDropRates[index] + prevChance
		if percentage <= chance:
			item = _Items[index]
			break;
		prevChance = chance
		
	return item.instantiate()
