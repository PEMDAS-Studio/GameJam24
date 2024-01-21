extends Control
class_name RewardManager

@onready var Option1Description = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option1/ColorRect/MarginContainer/Control/RichTextLabel
@onready var Option2Description = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option2/ColorRect/MarginContainer/Control/RichTextLabel
@onready var Option3Description = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option3/ColorRect/MarginContainer/Control/RichTextLabel
@onready var button1 = $CanvasLayer/Control/MarginContainer/HBoxContainer/Option1/ColorRect/MarginContainer/Button

signal RewardSelected

func _ready():
	button1.pressed.connect(_on_button_pressed.bind(1))
	_GenerateReward()
	Option1Description.text = _firstOption.Description
	Option2Description.text = _secondOption.Description
	Option3Description.text = _thirdOption.Description

var _firstOption : BaseWeaponEffect
var _secondOption : BaseWeaponEffect
var _thirdOption : BaseWeaponEffect

func _GenerateReward():
	_firstOption = AvaibableBuffList.Buffs.pick_random()
	_firstOption.BuildDescription()
	_secondOption = AvaibableBuffList.Buffs.pick_random()
	_secondOption.BuildDescription()
	_thirdOption = AvaibableBuffList.Buffs.pick_random()
	_thirdOption.BuildDescription()

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
