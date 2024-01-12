class_name MainMenu
extends Control

@onready var spread_please_start = $MarginContainer/VBoxContainer/VBoxContainer2/Spread_Please_Start as Button
@onready var bad_grass_start = $MarginContainer/VBoxContainer/VBoxContainer2/Bad_Grass_Start as Button
@onready var exit_button = $MarginContainer/VBoxContainer/VBoxContainer2/Exit_Button as Button
@onready var start_level_one = preload("res://SpreadPlease/spread_please.tscn") as PackedScene
@onready var start_level_two = preload("res://BadGrass/grassgame.tscn") as PackedScene

func _ready():
	spread_please_start.button_down.connect(on_start_pressed_one)
	bad_grass_start.button_down.connect(on_start_pressed_two)
	exit_button.button_down.connect(on_exit_pressed)

func on_start_pressed_one() -> void:
	get_tree().change_scene_to_packed(start_level_one)

func on_start_pressed_two() -> void:
	get_tree().change_scene_to_packed(start_level_two)

func on_exit_pressed() -> void:
	get_tree().quit()
