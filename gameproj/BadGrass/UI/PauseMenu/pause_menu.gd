extends Control

var isGamePaused:bool = false

func _ready():
	pass
	


func _input(event):
	if Input.is_action_just_pressed("pause"):
		if isGamePaused == false:
			get_tree().paused = true
			isGamePaused = true
			return
	
	if Input.is_action_just_pressed("pause"):
		if isGamePaused == true:
			get_tree().paused = false
			isGamePaused = false
			return
	
			
func _process(delta):
	pass
