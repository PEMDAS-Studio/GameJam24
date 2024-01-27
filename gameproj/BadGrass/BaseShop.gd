extends Control
class_name BaseShop

@onready var AmmoButton = $CanvasLayer/Control/MarginContainer/ColorRect/MarginContainer/Control2/ScrollContainer/HBoxContainer/Control/ColorRect/Button
@onready var ShotgunAmmoButton = $CanvasLayer/Control/MarginContainer/ColorRect/MarginContainer/Control2/ScrollContainer/HBoxContainer/Control2/ColorRect/Button
@onready var TurrentButton = $CanvasLayer/Control/MarginContainer/ColorRect/MarginContainer/Control2/ScrollContainer/HBoxContainer/Control3/ColorRect/Button
@onready var BeaconButton = $CanvasLayer/Control/MarginContainer/ColorRect/MarginContainer/Control2/ScrollContainer/HBoxContainer/Control4/ColorRect/Button
@onready var UpgradeBeaconButton = $CanvasLayer/Control/MarginContainer/ColorRect/MarginContainer/Control2/ScrollContainer/HBoxContainer/Control5/ColorRect/Button
@onready var upgradeTurretButton = $CanvasLayer/Control/MarginContainer/ColorRect/MarginContainer/Control2/ScrollContainer/HBoxContainer/Control6/ColorRect/Button
@onready var charCurrency = $CanvasLayer/Control/MarginContainer/ColorRect/Currency/Label
var charStatRef : CharacterStats

var BeaconStat : BeaconStats
var TurretStat : TurretStats

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("pause")):
		get_tree().paused = false
		queue_free()
	
	charCurrency.text = str(charStatRef.Currency)
	if charStatRef.AmmoCapacity == charStatRef.MaxAmmoCapacity:
		AmmoButton.disabled = true
	else:
		AmmoButton.disabled = false
		
	if charStatRef.ShotgunAmmoCapacity == charStatRef.MaxhShotgunAmmoCapacity:
		ShotgunAmmoButton.disabled = true
	else:
		ShotgunAmmoButton.disabled = false
	
	if charStatRef.TurretCount == charStatRef.MaxTurretCount:
		TurrentButton.disabled = true
	else:
		TurrentButton.disabled = false
		
	if charStatRef.BeaconCount == charStatRef.MaxBeaconCount:
		BeaconButton.disabled = true
	else:
		BeaconButton.disabled = false
		
	if TurretStat.lvl == TurretStat.lvls.size() - 1:
		upgradeTurretButton.disabled = true
	else:
		upgradeTurretButton.disabled = false
		
	if BeaconStat.lvl == BeaconStat.lvls.size() - 1:
		UpgradeBeaconButton.disabled = true
	else:
		UpgradeBeaconButton.disabled = false
		
func Init(stats, turretStats, beaconStats):
	charStatRef = stats
	BeaconStat = beaconStats
	TurretStat = turretStats

func _on_exit_button_pressed():
	get_tree().paused = false
	queue_free()

func _on_ammo_purchase():
	var cost = int(AmmoButton.text)
	if (charStatRef.Currency >= cost):
		charStatRef.Currency -= cost
		charStatRef.AmmoCapacity += 20

func _on_shotgun_ammo_purchase():
	var cost = int(ShotgunAmmoButton.text)
	if (charStatRef.Currency >= cost):
		charStatRef.Currency -= cost
		charStatRef.ShotgunAmmoCapacity += 6

func _on_turret_purchase():
	var cost = int(TurrentButton.text)
	if (charStatRef.Currency >= cost):
		charStatRef.Currency -= cost
		charStatRef.TurretCount += 1

func _on_beacon_purchase():
	var cost = int(BeaconButton.text)
	if (charStatRef.Currency >= cost):
		charStatRef.Currency -= cost
		charStatRef.BeaconCount += 1

func _on_beacon_upgrade():
	var cost = int(UpgradeBeaconButton.text)
	if (charStatRef.Currency >= cost && BeaconStat.lvl < BeaconStat.lvls.size()):
		charStatRef.Currency -= cost
		BeaconStat.lvl += 1
		BeaconStat.DeconSpeed = BeaconStat.lvls[BeaconStat.lvl]

func _on_turret_upgrade():
	var cost = int(upgradeTurretButton.text)
	if (charStatRef.Currency >= cost && TurretStat.lvl < TurretStat.lvls.size()):
		charStatRef.Currency -= cost
		TurretStat.lvl += 1
		TurretStat.AmmonCapacity = TurretStat.lvls[TurretStat.lvl]
