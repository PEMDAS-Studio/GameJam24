extends Control
class_name MainMenu

@onready var bad_grass_start = $MarginContainer/VBoxContainer2/Bad_Grass_Start as Button
@onready var setting_button = $MarginContainer/VBoxContainer2/Setting_Button as Button
@onready var exit_button = $MarginContainer/VBoxContainer2/Exit_Button as Button
@onready var start_level = load("res://BadGrass/grassgame.tscn") as PackedScene
@onready var audioPlayer = $AudioStreamPlayer as AudioStreamPlayer
@onready var settings_menu = $Settings_Menu as SettingsMenu
@onready var settings = load("res://main_menu/Settings Menu/settings_menu.tscn") as PackedScene


func _ready():
	AvaibableBuffList.ResetBuffs()
	handle_connecting_signals()
	Input.set_use_accumulated_input(false)
	
	var lamda = func ():
		audioPlayer.play()
	
	audioPlayer.finished.connect(lamda)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_setting_pressed() -> void:
	var scene = settings.instantiate()
	add_child(scene)

func on_exit_pressed() -> void:
	get_tree().quit()

func handle_connecting_signals() -> void:
	bad_grass_start.button_down.connect(on_start_pressed)
	setting_button.button_down.connect(on_setting_pressed)
	exit_button.button_down.connect(on_exit_pressed)
