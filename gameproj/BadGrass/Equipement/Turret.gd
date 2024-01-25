extends Node2D

var targets = []
var target
var bulletscene : PackedScene = preload("res://BadGrass/bullet/bullet_sample.tscn") 
var _isAttacking = false
var attackTimer : Timer
var AmmoCapacity = 40

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	attackTimer = Timer.new()
	attackTimer.one_shot = true
	add_child(attackTimer)
	attackTimer.wait_time = 0.4
	var my_lambda = func ():
		_isAttacking = false
	attackTimer.timeout.connect(my_lambda)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target == null && !targets.is_empty():
		target = targets.pick_random()
	
	if target == null:
		return
	
	if _isAttacking:
		return
		
	var pos = target.global_position
	var direction = Vector2(pos.x - global_position.x, pos.y - global_position.y).normalized()
	if pos.x > global_position.x:
		sprite.flip_h = false
	elif pos.x < global_position.x:
		sprite.flip_h = true
		
	_isAttacking = true
	attackTimer.start()
	var bullet = bulletscene.instantiate() as Bullet
	var position = global_position
	bullet.global_position = position
	bullet.disableDecon()
	bullet.SetProperties(3, 1.4, 1)
	get_tree().root.add_child(bullet)
	bullet.Shoot(direction, atan2(direction.y, direction.x))
	AmmoCapacity -= 1
	if AmmoCapacity == 0:
		queue_free()

func _on_area_2d_body_entered(body):
	if body is Enemy:
		targets.append(body)


func _on_area_2d_body_exited(body):
	if body is Enemy:
		targets.erase(body)
		if target == body:
			target = null
