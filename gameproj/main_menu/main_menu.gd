class_name MainMenu
extends Control

@onready var bad_grass_start = $MarginContainer/VBoxContainer/VBoxContainer2/Bad_Grass_Start as Button
@onready var setting_button = $MarginContainer/VBoxContainer/VBoxContainer2/Setting_Button as Button
@onready var exit_button = $MarginContainer/VBoxContainer/VBoxContainer2/Exit_Button as Button
@onready var start_level_two = preload("res://BadGrass/grassgame.tscn") as PackedScene

func _ready():
	handle_connecting_signals()

func on_start_pressed_two() -> void:
	get_tree().change_scene_to_packed(start_level_two)

func on_setting_pressed() -> void:
	print("LOAD SETTINGS MENU")

func on_exit_pressed() -> void:
	get_tree().quit()

func handle_connecting_signals() -> void:
	bad_grass_start.button_down.connect(on_start_pressed_two)
	setting_button.button_down.connect(on_setting_pressed)
	exit_button.button_down.connect(on_exit_pressed)
