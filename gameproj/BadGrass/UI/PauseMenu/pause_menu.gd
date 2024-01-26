extends CanvasLayer

var isGamePaused:bool = false
@onready var pause_menu = $PauseMenu
var isPausedExternally = false

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
		print("Paused")
		return
	
	if isGamePaused == true:
		pause_menu.hide()
		get_tree().paused = false
		isGamePaused = false
		print("Resumed")
		return

func _on_exit_pressed():
	get_tree().quit()

func updatePausedState(isPaused):
	isPausedExternally = isPaused
