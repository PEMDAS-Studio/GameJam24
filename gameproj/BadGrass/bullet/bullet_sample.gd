extends Area2D

@export var traversalVelocity: int = 256
@export var maxRange: int = 124
var _traversalDirection: Vector2
var _traveledDistance : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = _traversalDirection * delta
	position += distance
	_traveledDistance += distance.length()
	look_at(get_global_mouse_position())
	if _traveledDistance > maxRange:
		queue_free()

func Shoot(direction: Vector2, angle: float):
	_traversalDirection = direction * traversalVelocity
	set_process(true)
