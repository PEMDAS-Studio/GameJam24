extends Node

var FloatingTextScene : PackedScene

func CreateOrUseDamageFloat(damage: float, position: Vector2):
	var textScene : FloatingText = _GetScene().instantiate()
	textScene.global_position = position
	textScene.SetColor(Color.GREEN if damage < 0 else Color.WHITE)
	textScene.SetText(abs(damage))
	
	get_tree().current_scene.add_child(textScene)

func _GetScene() -> PackedScene:
	if FloatingTextScene == null:
		FloatingTextScene = load("res://BadGrass/FloatingText.tscn")
		
	return FloatingTextScene
