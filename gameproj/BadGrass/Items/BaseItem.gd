extends Node2D
class_name BaseItem

@export var Effect : CharacterStatEffect
@onready var sprite : Sprite2D = $Sprite2D 

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position", position + Vector2(0, 5), .8)
	tween.tween_property(self, "position", position + Vector2(0, -5), .8)
	tween.play()

func _on_pick_up(body):
	if body is Character:
		var item = PickedItem.new()
		item.StatusEffect = Effect
		item.SpriteSource = sprite.texture.resource_path
		
		body.Items.append(item)
		body.UseItem()
		queue_free()
