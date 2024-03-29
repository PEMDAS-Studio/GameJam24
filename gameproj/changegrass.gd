extends Node

@onready var character = $Player as Character
@onready var tile_map : TileMap = $TileMap
@onready var decontaminator : DecontaminatorBase = $Decontaminator
@onready var UiOverlay = $GameOverlay as GameOverlay
var _contaminatedTiles : Dictionary = {}
var _spreadableTiles : Array[Vector2i]

@onready var borderLeft = $StaticBody2D/CollisionShape2D
@onready var borderBottom = $StaticBody2D/CollisionShape2D2
@onready var borderRight = $StaticBody2D/CollisionShape2D3
@onready var borderTop = $StaticBody2D/CollisionShape2D4
@onready var camera = $Player/Camera2D
@onready var audioPlayer = $"../AudioStreamPlayer" as AudioStreamPlayer
@onready var pauseMenu = $"../PauseMenu"

@onready var path : PathFollow2D = $Player/Path2D/PathFollow2D

var RewardScene : PackedScene = preload("res://BadGrass/RewardManager.tscn")
var enemy:PackedScene = preload("res://BadGrass/Enemies/enemy.tscn")
const enemy_2:PackedScene = preload("res://BadGrass/Enemies/enemy2.tscn")
var gameOverScene:PackedScene = preload("res://main_menu/GameOver/game_over.tscn")
var enemySpawnTimer:float = 0.5
@export var enemyDiffCurve : Curve
@export var enemyDiffSpikePoint : int
@export var contaminationDiffCurve : Curve
@export var contaminationDiffSpikePoint : int

var spawnTimer : Timer
var enemyKilled = 0 
var currentEnemies = 0
var spreadTimer : Timer
signal StopWatch

@export var ItemDropPercentage : float
var elapsedTime : float
var min : int
var seconds : int

# Called when the node enters the scene tree for the first time.
func _ready():
	elapsedTime = 0
	path = get_tree().current_scene.find_child("PathFollow2D", true, false)
	character.LeveledUp.connect(_SelectReward.unbind(2))
	character.Stats.changed.connect(UiOverlay.UpdateHealthBar.bind(character.Stats))
	character.LeveledUp.connect(UiOverlay.UpdateLevelUpExperience)
	character.XpChanged.connect(UiOverlay.UpdateExperience)
	character.Decontaminated.connect(UpdateContaminationArray)
	character.Stats.Died.connect(GameEnded)
	character.ChangedWeapon.connect(UiOverlay.UpdateAmmoAndSprite)
	UiOverlay.HealthBar.max_value = character.Stats.MaxHealth
	UiOverlay.HealthBar.value = character.Stats.Health
	UiOverlay.XpBar.value = 0
	UiOverlay.XpBar.max_value = character.GetXpToNextLevel()
	UiOverlay.DashBar1.max_value = character.Stats.DashCharge / 2
	UiOverlay.DashBar1.value = UiOverlay.DashBar1.max_value
	UiOverlay.DashBar2.max_value = character.Stats.DashCharge
	UiOverlay.DashBar2.value = UiOverlay.DashBar2.max_value
	StopWatch.connect(UiOverlay.UpdateTime)
	character.Stats.CurrencyUpdated.connect(UiOverlay.UpdateAquiredCurrency)
	decontaminator.ShopOpenStat.connect(pauseMenu.updatePausedState)
	decontaminator.BaseDestroyed.connect(GameEnded)
	
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

	camera.limit_left = borderLeft.global_position.x
	camera.limit_bottom = borderBottom.global_position.y
	camera.limit_right = borderRight.global_position.x
	camera.limit_top = borderTop.global_position.y
	
	spawnTimer = Timer.new()
	spawnTimer.autostart = true
	spawnTimer.one_shot = false
	spawnTimer.wait_time = enemyDiffCurve.sample(0)
	spawnTimer.timeout.connect(_spawnEnemy)
	add_child(spawnTimer)
	spawnTimer.start()
	
	spreadTimer = Timer.new()
	spreadTimer.one_shot = false
	spreadTimer.wait_time = contaminationDiffCurve.sample(0)
	spreadTimer.autostart = true
	spreadTimer.timeout.connect(spreadContamination)
	add_child(spreadTimer)
	spreadTimer.start()
	
	var audio_lamda = func ():
		audioPlayer.play()
	
	audioPlayer.finished.connect(audio_lamda)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsedTime += delta
	
	spawnTimer.wait_time = enemyDiffCurve.sample(enemyKilled/enemyDiffSpikePoint)
	spreadTimer.wait_time = contaminationDiffCurve.sample(elapsedTime/contaminationDiffSpikePoint)
	
	seconds = int(elapsedTime) % 60
	min = int(elapsedTime) / 60
	emit_signal("StopWatch", seconds, min)
	
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

func UpdateContaminationArray(tilePos: Vector2i):
	_contaminatedTiles.erase(tilePos)
	var neightbouringTiles = tile_map.get_surrounding_cells(tilePos)
	
	for neighbour in neightbouringTiles:
		if tile_map.get_cell_source_id(0, neighbour) == 1:
			_contaminatedTiles[neighbour] = false
			if _spreadableTiles.find(neighbour) == -1:
				_spreadableTiles.append(neighbour)

func _SelectReward():
	var scene = RewardScene.instantiate() as RewardManager
	scene.RewardSelected.connect(character.AttachReward)
	
	var lamda = func ():
		pauseMenu.updatePausedState(false)
	scene.RewardSelected.connect(lamda.unbind(1))
	
	get_tree().paused = true
	pauseMenu.updatePausedState(true)
	get_tree().root.add_child(scene)

func _spawnEnemy():
	if currentEnemies >= 80:
		return
	var prograess = RandomNumberGenerator.new().randf_range(0, 1)
	path.set_progress_ratio(prograess)
	
	var enemyPotentialXPos = randf_range(256, 1087)
	var enemyPotentialYPos = randf_range(-40, 558)
	var randomEnemy = randi_range(0,10)
	var enemyInstance
	if randomEnemy % 2 == 0:
		enemyInstance = enemy.instantiate()
	else:
		enemyInstance = enemy_2.instantiate()
	enemyInstance.Stats = EnemyStats.new()
	#enemyInstance.position = Vector2(enemyPotentialXPos,enemyPotentialYPos)
	var enemyDeathLamda : Callable = func(enemy):
		var rand = randf_range(0, 100)
		if rand < ItemDropPercentage:
			_DropItem(enemy)
		enemyKilled += 1
		currentEnemies -= 1
		character.Stats.Currency += 2
	
	enemyInstance.connect("tree_exited", enemyDeathLamda.bind(enemyInstance))
	add_child(enemyInstance)
	enemyInstance.global_position = path.global_position
	if enemyKilled > 50 && enemyKilled <= 125:
		enemyInstance.Stats.Health *= 2
	elif  enemyKilled > 125 && enemyKilled < 200:
		enemyInstance.Stats.Health *= 4
		enemyInstance.damage *= 1.75
	elif enemyKilled >= 200:
		enemyInstance.Stats.Health *= 6
		enemyInstance.damage *= 2.75

func _DropItem(enemy):
	var instance = AvailableItems.GetItem()
	instance.global_position = enemy.global_position
	add_child(instance)

func GameEnded():
	call_deferred("_endGame")

func _endGame():
	get_tree().change_scene_to_packed(gameOverScene)
