extends Node

var _Items : Array[Resource] = [
	load("res://BadGrass/Items/SampleItem.tscn"),
	load("res://BadGrass/Items/SampleItemSpeed.tscn")
]

var _ItemDropRates : Array[int] = [68, 65] 

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
