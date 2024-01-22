class_name GameOver
extends Control

@onready var restart_button = $MarginContainer/VBoxContainer/VBoxContainer/Restart_Button as Button
@onready var restart_screen = preload("res://main_menu/main_menu.tscn") as PackedScene

func on_restart_screen() -> void:
	get_tree().change_scene_to_packed(restart_screen)
