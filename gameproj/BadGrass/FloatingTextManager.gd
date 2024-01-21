extends Node

var FloatingTextScene : PackedScene

func CreateOrUseDamageFloat(damage: float, position: Vector2):
	var textScene : FloatingText = _GetScene().instantiate()
	textScene.global_position = position
	textScene.SetText(damage)
	#textScene.SetColor(Color(1, 0, 0, 1))
	
	get_tree().current_scene.add_child(textScene)

func _GetScene() -> PackedScene:
	print_debug("eeeeeeh")
	if FloatingTextScene == null:
		FloatingTextScene = load("res://BadGrass/FloatingText.tscn")
		
	return FloatingTextScene
