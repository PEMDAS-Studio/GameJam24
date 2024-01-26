extends Node2D

@onready var decontaminationTimer : Timer = $Timer
@export var Stats : BeaconStats

var tile_map : TileMap
var gameScene
signal decontaminatedTile

# Called when the node enters the scene tree for the first time.
func _ready():
	gameScene = get_tree().current_scene.find_child("Grassgame", true, false)
	tile_map = gameScene.find_child("TileMap", true, false)
	decontaminatedTile.connect(gameScene.UpdateContaminationArray)
	
	decontaminationTimer.one_shot = false
	decontaminationTimer.wait_time = Stats.DeconSpeed
	decontaminationTimer.timeout.connect(decontaminateSurrounding)
	decontaminationTimer.start()

func _process(delta):
	decontaminationTimer.wait_time = Stats.DeconSpeed

func decontaminateSurrounding():
	var tile_pos : Vector2i = tile_map.local_to_map(global_position - Vector2(16, 0)) / 4
	var neightbouringTiles = tile_map.get_surrounding_cells(tile_pos)
	var possibleTiles = []
	neightbouringTiles.append(Vector2i(tile_pos.x + 1, tile_pos.y + 1))
	neightbouringTiles.append(Vector2i(tile_pos.x + 1, tile_pos.y - 1))
	neightbouringTiles.append(Vector2i(tile_pos.x - 1, tile_pos.y + 1))
	neightbouringTiles.append(Vector2i(tile_pos.x - 1, tile_pos.y - 1))
	neightbouringTiles.append(tile_pos)
	
	for neighbour in neightbouringTiles:
		if tile_map.get_cell_source_id(0, neighbour) == 1:
			possibleTiles.append(neighbour)
	
	if (possibleTiles.is_empty()):
		return
	
	var selectedTile = possibleTiles.pick_random()
	
	var atlas_coord : Vector2i = tile_map.get_cell_atlas_coords(0, selectedTile)
	tile_map.set_cell(0, selectedTile,0, atlas_coord)
	Stats.ChargeCapacity -= Stats.DeconChargeCost
