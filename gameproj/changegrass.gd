extends Node

@onready var character = $CharacterBody2D
@onready var tile_map : TileMap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _unhandled_input(event):
	if Input.is_action_just_pressed("grassaction"):
		#var charPos : Vector2 = position;
		var tile_pos : Vector2i = tile_map.local_to_map(character.global_position) - Vector2i(7, 4);
		var atlas_coord : Vector2i = Vector2i(0,0);
		tile_map.set_cell(0, tile_pos,0, atlas_coord);
		pass
