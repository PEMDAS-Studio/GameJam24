extends Control
class_name RewardManager

@onready var Option1Description = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option1/ColorRect/MarginContainer/Control/RichTextLabel
@onready var Option2Description = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option2/ColorRect/MarginContainer/Control/RichTextLabel
@onready var Option3Description = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option3/ColorRect/MarginContainer/Control/RichTextLabel
@onready var button1 = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option1/ColorRect/MarginContainer/Button
@onready var SecondOption = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option2
@onready var ThirdOption = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option3
signal RewardSelected
var availableBuff : Array[BaseWeaponEffect] = []

func _ready():
	availableBuff = AvaibableBuffList.Buffs.duplicate()
	_GenerateReward()
	
	if (_firstOption == null):
		get_tree().paused = false
		queue_free()
		return
	Option1Description.text = _firstOption.Description
	
	if (_secondOption == null):
		SecondOption.queue_free()
		ThirdOption.queue_free()
		return
	Option2Description.text = _secondOption.Description
	
	if (_thirdOption == null):
		ThirdOption.queue_free()
		return
	Option3Description.text = _thirdOption.Description

var _firstOption : BaseWeaponEffect
var _secondOption : BaseWeaponEffect
var _thirdOption : BaseWeaponEffect

func _GenerateReward():
	_firstOption = _GetBuff()
	if _firstOption == null:
		return
	_firstOption.BuildDescription()
	
	_secondOption = _GetBuff()
	if _secondOption == null:
		return
	_secondOption.BuildDescription()
	
	_thirdOption = _GetBuff()
	if _thirdOption == null:
		return
	_thirdOption.BuildDescription()
	
func _GetBuff() -> BaseWeaponEffect: 
	if availableBuff.is_empty():
		return null
	var buff = availableBuff.pick_random() as BaseWeaponEffect
	if buff.Level == buff.EffectLevels.size():
		availableBuff.erase(buff)
		return _GetBuff()
	
	availableBuff.erase(buff)
	return buff
	
func _on_button_pressed(option:int):
	if option == 1:
		_firstOption.EffectDetail = _firstOption.EffectLevels[_firstOption.Level]
		_firstOption.Level += 1
		emit_signal("RewardSelected", _firstOption)
	elif option == 2:
		_secondOption.EffectDetail = _secondOption.EffectLevels[_secondOption.Level]
		_secondOption.Level += 1
		emit_signal("RewardSelected", _secondOption)
	else:
		_thirdOption.EffectDetail = _thirdOption.EffectLevels[_thirdOption.Level]
		_thirdOption.Level += 1
		emit_signal("RewardSelected", _thirdOption)
	
	get_tree().paused = false
	queue_free()
