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
		var tile_pos : Vector2i = tile_map.local_to_map(character.global_position)
		var tile_source = tile_map.get_cell_source_id(0, tile_pos);
		if tile_source == 0:
			make_tile_purple(tile_pos);
		elif tile_source == 1: 
			make_tile_green(tile_pos);

	
func make_tile_green(tile_pos):
	var atlas_coord : Vector2i = tile_map.get_cell_atlas_coords(0, tile_pos);
	tile_map.set_cell(0, tile_pos,0, atlas_coord);

func make_tile_purple(tile_pos):
	var atlas_coord : Vector2i = tile_map.get_cell_atlas_coords(0, tile_pos);
	tile_map.set_cell(0, tile_pos, 1, atlas_coord);
