extends Node2D

@export var Effect : CharacterStatEffect

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position", position + Vector2(0, 5), .8)
	tween.tween_property(self, "position", position + Vector2(0, -5), .8)
	tween.play()


func _on_pick_up(body):
	if body is Character:
		body.Items.append(Effect)
		queue_free()
