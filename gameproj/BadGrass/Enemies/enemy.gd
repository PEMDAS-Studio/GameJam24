extends BaseEnemy
class_name Enemy

var XpAmount = 10

@export var Stats  : EnemyStats
@onready var Player:Object = get_parent().get_node("Player")
@onready var anim = $Anim
@onready var hurt_time = $HurtTime
@onready var marker = $Marker2D
@onready var audioPlayer = $AudioStreamPlayer2D
@onready var characterAudPlayer = $CharacterHit

var pickUp:PackedScene = preload("res://BadGrass/Enemies/pickup.tscn")

var damage:float = 5
var hadDied = false

func _ready():
	Stats.Health = 25
	Stats.Speed = 210.0
	Stats.OriginalSpeed = 210.0
	Stats.HealthChanged.connect(HealthChange)
	anim.play("Run")

func _physics_process(delta):
	if Stats.Health <= 0:
		return
	var playerPos = Player.global_position / 4
	if playerPos.x - position.x < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
	
	velocity = position.direction_to(playerPos) * Stats.Speed
	
	move_and_slide()

func _on_hit_box_area_entered(area):
	if area.get_name() == "BulletSample":
		area.piercing -= 1
		Stats.Health -= area.damage
		audioPlayer.play()
		var tween = create_tween()
		tween.tween_property(self, "modulate:v", 1, 0.25).from(15)
		#For every status effect, attempt an application of the effect
		for effect in area.StatusEffects:
			var result = effect.ApplyEffect(self)
	elif area.get_parent().get_name() == "ShotgunBullet":		
		Stats.Health -= area.get_parent().damage
		area.get_parent().piercing -= 1
		audioPlayer.play()
		var tween = create_tween()
		tween.tween_property(self, "modulate:v", 1, 0.25).from(15)
		#For every status effect, attempt an application of the effect
		for effect in area.get_parent().StatusEffects:
			var result = effect.ApplyEffect(self)
	
	if Stats.Health <= 0 && !hadDied:
		hadDied = true
		set_deferred("collision_layer", 0)
		set_deferred("collision_mask", 0)
		var callback = func():
			if anim.animation == "Death":
				var pickup = pickUp.instantiate()
				pickup.XpAmount = XpAmount
				pickup.position = self.position
				get_parent().add_child(pickup)
				queue_free()
				
		anim.animation_finished.connect(callback)
		anim.play("Death")
	
func _on_hurt_box_body_entered(body):
	if Stats.Health <= 0:
		return
	if body.get_name() == "Player":
		anim.play("Hit")
		hurt_time.start(0.8)

func _on_hurt_box_body_exited(body):
	if Stats.Health <= 0:
		return
		
	if body.get_name() == "Player":
		anim.play("Run")
		hurt_time.stop()

func _on_hurt_time_timeout():
	Player.Stats.Health -= damage
	characterAudPlayer.play()

func HealthChange(dmg):
	FloatingTextManager.CreateOrUseDamageFloat(dmg, marker.global_position).SetOutline(Color(0,0,0,0), 2)
