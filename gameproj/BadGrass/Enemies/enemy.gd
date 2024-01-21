extends CharacterBody2D
class_name Enemy

const SPEED = 70.0
var XpAmount = 10

@export var Stats  : EnemyStats
@onready var Player:Object = get_parent().get_node("Player")
@onready var anim = $Anim
@onready var hurt_time = $HurtTime
@onready var marker = $Marker2D

var pickUp:PackedScene = preload("res://BadGrass/Enemies/pickup.tscn")

var damage:float = 5

func _ready():
	Stats.Health = 25
	Stats.HealthChanged.connect(HealthChange)
	anim.play("Run")

func _physics_process(delta):
	var playerPos = Player.global_position
	if playerPos.x - position.x < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
	
	velocity = position.direction_to(playerPos) * SPEED
	
	if Stats.Health < 0:
		var pickup = pickUp.instantiate()
		pickup.XpAmount = XpAmount
		pickup.position = self.position
		get_parent().add_child(pickup)
		queue_free()
	
	move_and_slide()

func _on_hit_box_area_entered(area):
	if area.get_name() == "BulletSample":
		Stats.Health -= area.damage
		#For every status effect, attempt an application of the effect
		for effect in area.StatusEffects:
			var result = effect.ApplyEffect(self)
			
func _on_hurt_box_body_entered(body):
	if body.get_name() == "Player":
		anim.play("Hit")
		hurt_time.start(1)

func _on_hurt_box_body_exited(body):
	if body.get_name() == "Player":
		anim.play("Run")
		hurt_time.stop()

func _on_hurt_time_timeout():
	Player.Stats.Health -= damage

func HealthChange(dmg):
	if (Stats.Health <= 0):
		return
	FloatingTextManager.CreateOrUseDamageFloat(dmg, marker.global_position)
