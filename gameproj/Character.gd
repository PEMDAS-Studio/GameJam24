extends CharacterBody2D

@export var SPEED = 72.0
@onready var sprite = $Sprite2D as AnimatedSprite2D

func _physics_process(delta):
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
	
	


