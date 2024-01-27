extends Node2D
class_name DecontaminatorBase

@export var Stats : Base
var _timer = Timer.new()
var Interactable = false
var ShopScene = load("res://BadGrass/BaseShop.tscn")
# Called when the node enters the scene tree for the first time.
signal ShopOpenStat
var CharStats
var BeaconStat
var TurretStat
@onready var text = $RichTextLabel

signal BaseDestroyed

func _ready():
	text.visible = false
	Stats = Stats.duplicate()
	Stats.AutomateResources(self)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Stats.Health == 0):
		_timer.stop()
		emit_signal("BaseDestroyed")
		
	if (Interactable && Input.is_action_pressed("Interact")):
		var scene = ShopScene.instantiate() as BaseShop
		emit_signal("ShopOpenStat", true)
		
		var lamda = func ():
			emit_signal("ShopOpenStat", false)
		scene.tree_exited.connect(lamda)
		
		get_tree().paused = true
		scene.Init(CharStats, TurretStat, BeaconStat)
		get_tree().root.add_child(scene)
			
func InitBase(tileSet: TileMap):
	_timer.one_shot = false
	_timer.wait_time = 1
	add_child(_timer)
	var my_lambda = func ():
		var hostileTileCount = _detectDamage(tileSet)
		Stats.Health -= hostileTileCount
		
	_timer.timeout.connect(my_lambda)
	_timer.start()

func _detectDamage(tileSet: TileMap) -> int :
	var numberOfSuroundingInfectedTiles : int = 0
	var baseTilePosition = tileSet.local_to_map(global_position)
		
	#detect 3*3 Sourounding tiles
	for yAxis in 3:
		for xAxis in 3:
			var position = baseTilePosition +  Vector2i(xAxis - 1, yAxis - 1)
			var tile_source = tileSet.get_cell_source_id(0, position)
			if (tile_source == 1):
				numberOfSuroundingInfectedTiles += 1
	
	return numberOfSuroundingInfectedTiles

func _on_interaction_zone_body_entered(body):
	if body is Character:
		Interactable = true
		CharStats = body.Stats
		TurretStat = body.turretStatCopy
		BeaconStat = body.beaconStatCopy
		text.visible = true
		
func _on_interaction_zone_body_exited(body):
	if body is Character:
		Interactable = false
		text.visible = false
