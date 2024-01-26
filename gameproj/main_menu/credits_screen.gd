class_name CreditsScreen
extends Control

@onready var exit_button = $Exit_Button as Button
@onready var main_menu = load("res://main_menu/main_menu.tscn") as PackedScene

func _ready():
	handle_connecting_signals()

func on_exit_pressed() -> void:
	queue_free()

func handle_connecting_signals() -> void:
	exit_button.button_down.connect(on_exit_pressed)
