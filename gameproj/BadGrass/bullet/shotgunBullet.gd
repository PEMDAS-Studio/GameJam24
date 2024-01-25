extends Node2D
class_name  shotgunBullet

@export var traversalVelocity: int = 768
@export var maxRange: int = 256
@onready var pellet1 = $Area2D
@onready var pelett2 = $Area2D2
@onready var pelete3 = $Area2D3
var StatusEffects : Array[BaseWeaponStatusEffect]

var _traversalDirection: Vector2
var _traveledDistance : float = 0
var piercing: int
var damage:float

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(get_global_mouse_position())
	var distance = _traversalDirection * delta
	pellet1.global_position += distance.rotated(pellet1.get_rotation())
	pelett2.global_position += distance.rotated(pelett2.get_rotation())
	pelete3.global_position += distance.rotated(pelete3.get_rotation())
	_traveledDistance += distance.length()
	
	if _traveledDistance > maxRange || piercing <= 0:
		queue_free()

func Shoot(direction: Vector2, angle: float):
	_traversalDirection = direction * traversalVelocity
	set_process(true)

func SetProperties(dmgValue, reachImprovement, piercingValue):
	damage = round(dmgValue/2 * pow(10.0, 2)) / pow(10.0, 2) 
	maxRange *= reachImprovement
	piercing = piercingValue * 3
