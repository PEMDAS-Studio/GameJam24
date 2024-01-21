extends Node

@onready var character = $Player as Character
@onready var tile_map : TileMap = $TileMap
@onready var decontaminator : DecontaminatorBase = $Decontaminator
@onready var UiOverlay = $GameOverlay as GameOverlay
var _contaminatedTiles : Dictionary = {}
var _spreadableTiles : Array[Vector2i]

var RewardScene : PackedScene = preload("res://BadGrass/RewardManager.tscn")
var enemy:PackedScene = preload("res://BadGrass/Enemies/enemy.tscn")
var enemySpawnTimer:float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	character.LeveledUp.connect(_SelectReward.unbind(2))
	character.Stats.changed.connect(UiOverlay.UpdateHealthBar.bind(character.Stats))
	character.LeveledUp.connect(UiOverlay.UpdateLevelUpExperience)
	character.XpChanged.connect(UiOverlay.UpdateExperience)
	UiOverlay.HealthBar.max_value = character.Stats.MaxHealth
	UiOverlay.HealthBar.value = character.Stats.Health
	UiOverlay.XpBar.value = 0
	UiOverlay.XpBar.max_value = character.GetXpToNextLevel()
	
	decontaminator.InitBase(tile_map)
	var tiles = tile_map.get_used_cells(0)
	for tile in tiles:
		if (tile_map.get_cell_source_id(0, tile) == 1):
			var isFullyContaminated = true
			for neighbourTile in tile_map.get_surrounding_cells(tile):
				if tile_map.get_cell_source_id(0, neighbourTile) == 0:
					isFullyContaminated = false
					_spreadableTiles.append(tile)
					break
					
			_contaminatedTiles[tile] = isFullyContaminated
	
	var timer = Timer.new()
	timer.one_shot = false
	timer.wait_time = 0.4
	add_child(timer)
	timer.timeout.connect(spreadContamination)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enemySpawnTimer -= delta
	if enemySpawnTimer < 0:
		var enemyPotentialXPos = randf_range(256, 1087)
		var enemyPotentialYPos = randf_range(-40, 558)
		var enemy = enemy.instantiate()
		enemy.Stats = EnemyStats.new()
		enemy.position = Vector2(enemyPotentialXPos,enemyPotentialYPos)
		add_child(enemy)
		enemySpawnTimer = 0.5
	
	
	
#func _unhandled_input(event):
	#if Input.is_action_just_pressed("grassaction"):
		#var tile_pos : Vector2i = tile_map.local_to_map(character.global_position)
		#var tile_source = tile_map.get_cell_source_id(0, tile_pos);
		#if tile_source == 0:
			#make_tile_purple(tile_pos);
		#elif tile_source == 1: 
			#make_tile_green(tile_pos);
	
func make_tile_green(tile_pos):
	var atlas_coord : Vector2i = tile_map.get_cell_atlas_coords(0, tile_pos);
	tile_map.set_cell(0, tile_pos,0, atlas_coord);

func make_tile_purple(tile_pos):
	var atlas_coord : Vector2i = tile_map.get_cell_atlas_coords(0, tile_pos);
	tile_map.set_cell(0, tile_pos, 1, atlas_coord);

func spreadContamination():
	if (_spreadableTiles.is_empty()):
		return
		
	var position : Vector2i
	var key = randi_range(0, _spreadableTiles.size() - 1)
	position = _spreadableTiles[key]
			
	var neightbouringTiles = tile_map.get_surrounding_cells(position)
	var possibleTiles : Array[Vector2i]
	for neighbour in neightbouringTiles:
		if tile_map.get_cell_source_id(0, neighbour) == 0:
			possibleTiles.append(neighbour)
	
	if possibleTiles.is_empty():
		_spreadableTiles.remove_at(key)
		return
		
	var neighbourkey = randi_range(0, possibleTiles.size() - 1)
	make_tile_purple(possibleTiles[neighbourkey])
	_spreadableTiles.append(possibleTiles[neighbourkey])
	_contaminatedTiles[possibleTiles[neighbourkey]] = false
	if possibleTiles.size() == 1:
		_spreadableTiles.remove_at(key)

func _SelectReward():
	var scene = RewardScene.instantiate() as RewardManager
	scene.RewardSelected.connect(character.AttachReward)
	get_tree().paused = true
	get_tree().root.add_child(scene)
