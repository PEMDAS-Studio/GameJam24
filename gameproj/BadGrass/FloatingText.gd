extends Marker2D

class_name FloatingText

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", global_position + _getVariationVector(), 0.7)
	$AnimationPlayer.play("Popup")

func SetText(text):
	$Label.text = str(text)

func SetColor(color : Color):
	$Label.set_modulate(color)

func _getVariationVector() -> Vector2:
	return Vector2(randf_range(-1, 1) * 4, -randf()* 8)
