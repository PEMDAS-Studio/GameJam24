extends CharacterBody2D

@export var SPEED = 72.0
@onready var sprite = $Sprite2D as AnimatedSprite2D
var _isAttacking = false
var attackTimer : Timer
var bulletscene : PackedScene = preload("res://BadGrass/bullet/bullet_sample.tscn") 

func _ready():
	attackTimer = Timer.new()
	attackTimer.one_shot = true
	add_child(attackTimer)
	attackTimer.wait_time = 0.4
	var my_lambda = func ():
		_isAttacking = false
	attackTimer.timeout.connect(my_lambda)
	set_motion_mode(MOTION_MODE_FLOATING);
	

func _physics_process(delta):
	if (Input.is_action_just_pressed("grassaction") && !_isAttacking):
		var mousePosition = get_global_mouse_position()
		_isAttacking = true
		attackTimer.start()
		var bullet = bulletscene.instantiate()
		var position = global_position
		bullet.global_position = position
		get_tree().root.add_child(bullet)
		var direction = Vector2(mousePosition.x - position.x, mousePosition.y - position.y).normalized()
		bullet.Shoot(direction, atan2(direction.y, direction.x))
	
	var xDirection = Input.get_axis("left", "right")
	var yDirection = Input.get_axis("up", "down")
	
	if xDirection:
		velocity.x = xDirection * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if yDirection:
		velocity.y = yDirection * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	var normalizedSpeed = velocity.normalized()
	velocity = SPEED * normalizedSpeed
	
	HandleAnimation()
	
	move_and_slide()

func HandleAnimation():
	if (velocity == Vector2.ZERO):
		sprite.pause()
		sprite.frame = 0
	
	if velocity.x > 0 && velocity.y == 0:
		sprite.play("Right")
	elif velocity.x < 0 && velocity.y == 0:
		sprite.play("Left")
	
	if velocity.y > 0:
		sprite.play("Down")
	elif velocity.y < 0:
		sprite.play("Up")
	
	


