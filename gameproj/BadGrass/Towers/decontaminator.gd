extends Node2D
class_name DecontaminatorBase

@export var Stats : Base
var _timer = Timer.new()

# Called when the node enters the scene tree for the first time.

func _ready():
	Stats = Stats.duplicate()
	Stats.AutomateResources(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Stats.Health == 0):
		print_debug("Base destroyed, Game ending.")
		set_process(false)
		_timer.stop()
		remove_child(_timer)
		
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
