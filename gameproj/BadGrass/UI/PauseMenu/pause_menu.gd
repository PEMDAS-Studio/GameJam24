extends CanvasLayer

var isGamePaused:bool = false
@onready var pause_menu = $PauseMenu
var isPausedExternally = false
@onready var settings = load("res://main_menu/Settings Menu/settings_menu.tscn") as PackedScene
@onready var main = load("res://main_menu/main_menu.tscn") as PackedScene

func _ready():
	pause_menu.hide()
	
func _input(event):
	if isPausedExternally:
		return
		
	if Input.is_action_just_pressed("pause"):
		PauseResume()

func _process(delta):
	pass

func _on_resume_pressed():
	PauseResume()
	
func PauseResume():
	if isGamePaused == false:
		pause_menu.show()
		get_tree().paused = true
		isGamePaused = true
		return
	
	if isGamePaused == true:
		pause_menu.hide()
		get_tree().paused = false
		isGamePaused = false
		return

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(main)

func updatePausedState(isPaused):
	isPausedExternally = isPaused

func _on_setting_pressed():
	var scene = settings.instantiate()
	add_child(scene)
