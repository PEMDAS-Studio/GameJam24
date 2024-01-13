extends Area2D

@export var traversalVelocity: int = 256
@export var maxRange: int = 124
var _traversalDirection: Vector2
var _traveledDistance : float = 0
var tile_map : TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	tile_map = get_tree().current_scene.find_child("TileMap", true, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = _traversalDirection * delta
	position += distance
	_traveledDistance += distance.length()
	look_at(get_global_mouse_position())
	if _traveledDistance > maxRange:
		var tile_pos : Vector2i = tile_map.local_to_map(global_position)
		var tile_source = tile_map.get_cell_source_id(0, tile_pos);
		if tile_source == 0:
			make_tile_purple(tile_pos);
		elif tile_source == 1: 
			make_tile_green(tile_pos);
		queue_free()

func Shoot(direction: Vector2, angle: float):
	_traversalDirection = direction * traversalVelocity
	set_process(true)

func make_tile_green(tile_pos):
	var atlas_coord : Vector2i = tile_map.get_cell_atlas_coords(0, tile_pos);
	tile_map.set_cell(0, tile_pos,0, atlas_coord);

func make_tile_purple(tile_pos):
	var atlas_coord : Vector2i = tile_map.get_cell_atlas_coords(0, tile_pos);
	tile_map.set_cell(0, tile_pos, 1, atlas_coord);