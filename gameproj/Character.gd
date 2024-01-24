extends CharacterBody2D
class_name Character

@export var _experience : int = 0
var _levelUpExperience : Array[int] = [90, 200, 400, 500, 760, 990, 1300, 1780, 2000, 2500, 3140, 3900, 5000, 7000, 9500, 13000, 17000, 25000]
var _level : int = 0
signal LeveledUp
signal XpChanged
signal Decontaminated 

@export var Stats : CharacterStats
@onready var sprite = $Sprite2D as AnimatedSprite2D
@onready var marker = $Marker2D
@onready var dashChargeTimer = $DashCharger

var _isAttacking = false
var attackTimer : Timer
var bulletscene : PackedScene = preload("res://BadGrass/bullet/bullet_sample.tscn") 
var shotgunbulletscene : PackedScene = preload("res://BadGrass/bullet/shotgunBullet.tscn") 
var beaconScene : PackedScene = preload("res://BadGrass/Equipement/Beacon.tscn")
var TurrentScene : PackedScene = preload("res://BadGrass/Equipement/Turret.tscn")
var _isDashing = false
var animation : String
var _activeGun
var _effects : Array[CharacterStatEffect] = []
var Items : Array[PickedItem] = []

## This seaction is to handle weapon setting but currently we are without weapons.
var aquiredWeaponEffects : Array[BaseWeaponStatusEffect] = []
var baseRegenTimer : Timer
var beaconCount = 0
var turretCount = 0

func GetLevel() -> int:
	return _level

func GetXpToNextLevel() -> int:
	return _levelUpExperience[_level]

func _ready():
	_activeGun = bulletscene
	dashChargeTimer.one_shot = false
	dashChargeTimer.timeout.connect(_chargeDash)
	attackTimer = Timer.new()
	attackTimer.one_shot = true
	add_child(attackTimer)
	attackTimer.wait_time = 0.4
	var my_lambda = func ():
		_isAttacking = false
	attackTimer.timeout.connect(my_lambda)
	set_motion_mode(MOTION_MODE_FLOATING);
	Stats.HealthChanger.connect(HealthChanged)
	
	#Base regen timer
	baseRegenTimer = Timer.new()
	baseRegenTimer.autostart = false
	baseRegenTimer.wait_time = Stats.RegenRate
	baseRegenTimer.one_shot = false
	var lamda = func():
		if (Stats.Health < Stats.MaxHealth):
			Stats.Health += Stats.BaseRegenAmount
	
	baseRegenTimer.timeout.connect(lamda)
	add_child(baseRegenTimer)
	baseRegenTimer.start()
	
func _physics_process(delta):
	attackTimer.wait_time = 0.4	if _activeGun == bulletscene else 0.7
	
	if (Input.is_action_pressed("grassaction") && !_isAttacking):
		Attack()
		
	if (Input.is_action_just_pressed("placeBeacon") && Stats.BeaconCount > 0 && beaconCount <= Stats.MaxBeaconCount):
		Stats.BeaconCount -= 1
		beaconCount += 1
		var beacon = beaconScene.instantiate()
		beacon.global_position = global_position/4
		var mainscene = get_tree().current_scene.find_child("Grassgame", true, false)
		mainscene.add_child(beacon)
		mainscene.move_child(beacon, get_index())
		
	if (Input.is_action_just_pressed("placeTurrent") && Stats.TurretCount > 0 && turretCount <= Stats.MaxTurretCount):
		Stats.TurretCount -= 1
		turretCount += 1
		var turrentInstance = TurrentScene.instantiate()
		var turretLamda = func ():
			turretCount -= 1
			
		turrentInstance.tree_exited.connect(turretLamda)
		turrentInstance.global_position = global_position/4
		var mainscene = get_tree().current_scene.find_child("Grassgame", true, false)
		mainscene.add_child(turrentInstance)
		mainscene.move_child(turrentInstance, get_index())
	
	if (Input.is_action_just_pressed("dash") && Stats.DashCharge >= 20 && !_isDashing && velocity != Vector2.ZERO):
		var dashTimer = Timer.new()
		dashTimer.one_shot = true
		add_child(dashTimer)
		var timer = Timer.new()
		dashTimer.timeout.connect(_endDash.bind(timer))
		timer.wait_time = 0.03
		timer.one_shot = false
		timer.timeout.connect(_createTrail)
		get_tree().root.add_child(timer)
		timer.start()
		dashTimer.wait_time = Stats.DashDuration
		dashTimer.start()
		_isDashing = true
		Stats.DashCharge -= 20
		collision_layer = 0
		collision_mask = 8
		
	if (Input.is_action_just_pressed("switchWeapons")):
		_activeGun = shotgunbulletscene if _activeGun == bulletscene else bulletscene
	
	var xDirection = Input.get_axis("left", "right")
	var yDirection = Input.get_axis("up", "down")
	
	var speed = Stats.DashSpeed if _isDashing else Stats.Speed
	
	if xDirection:
		velocity.x = xDirection * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if yDirection:
		velocity.y = yDirection * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
		
	var normalizedSpeed = velocity.normalized()
	velocity = speed * normalizedSpeed
	
	HandleAnimation()
	move_and_slide()

func HandleAnimation():
	if (velocity == Vector2.ZERO):
		sprite.pause()
		sprite.frame = 0
	
	if velocity.x > 0 && velocity.y == 0:
		animation = "Right"
	elif velocity.x < 0 && velocity.y == 0:
		animation = "Left"
	
	if velocity.y > 0:
		animation = "Down"
	elif velocity.y < 0:
		animation = "Up"
	
	sprite.play(animation)
	
	
func Attack():
	var mousePosition = get_global_mouse_position()
	_isAttacking = true
	attackTimer.start()
	var bullet = _activeGun.instantiate()
	var position = global_position
	bullet.global_position = position
	bullet.StatusEffects = aquiredWeaponEffects
	if (bullet.has_signal("DecontontaminatedTile")):
		bullet.DecontontaminatedTile.connect(_TileDecontaminated)
	
	get_tree().root.add_child(bullet)
	var direction = Vector2(mousePosition.x - position.x, mousePosition.y - position.y).normalized()
	bullet.Shoot(direction, atan2(direction.y, direction.x))
	
func ConsumeItem(item : PickedItem):
	var effect = item.StatusEffect
	for appliedEffect in _effects:
		if (appliedEffect.Name == effect.Name):
			return
	
	_effects.append(effect)
	effect.ApplyEffect(self)

func IncreaseXp(amount: int):
	_experience = _experience + amount
	if (_level == _levelUpExperience.size()):
			return
	if (_experience >= _levelUpExperience[_level]):
		if (_level == _levelUpExperience.size()):
			return
		var overflownXp = _experience - _levelUpExperience[_level]
		_experience = overflownXp
		_level += 1
		emit_signal("LeveledUp", _level, 0 if _level == _levelUpExperience.size() else _levelUpExperience[_level])
	emit_signal("XpChanged", _experience)

func UseItem():
	if !Items.is_empty():
		var item = Items[0]
		ConsumeItem(item)
		Items.remove_at(0)

func AttachReward(effect: BaseWeaponEffect):
	if (effect is BaseWeaponStatusEffect):
		var addbuff = true
		for aquiredEffect in aquiredWeaponEffects:
			if (effect.Name == aquiredEffect.Name):
				addbuff = false
		if (addbuff):
			aquiredWeaponEffects.append(effect)
	else:
		#UpdateState for bullet
		pass

func HealthChanged(damage):
	FloatingTextManager.CreateOrUseDamageFloat(damage, marker.global_position)
	
func _TileDecontaminated(pos: Vector2i):
	Decontaminated.emit(pos)

func _endDash(timer):
	_isDashing = false
	collision_layer = 1
	collision_mask = 9
	dashChargeTimer.start()
	dashChargeTimer.wait_time = Stats.DashChargeRate / 20
	timer.queue_free()
	
func _chargeDash():
	Stats.DashCharge += 1
	if Stats.DashCharge == 40:
		dashChargeTimer.stop()
		
func _createTrail():
	var trail = sprite.duplicate() as AnimatedSprite2D
	trail.scale = Vector2(4, 4)
	trail.global_position = global_position
	get_tree().root.add_child(trail)
	var trailTween = create_tween()
	trailTween.tween_property(trail, "modulate:a", 0.0, 0.3)
	trailTween.play()
	var my_lambda = func (sprite):
		sprite.queue_free()
	
	trailTween.finished.connect(my_lambda.bind(trail))
