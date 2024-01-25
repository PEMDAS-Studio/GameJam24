extends CanvasLayer
class_name GameOverlay

@onready var HealthBar = $HealthBar as TextureProgressBar
@onready var XpBar = $ExperienceBar as TextureProgressBar
@onready var DashBar1 = $DashBar1 as TextureProgressBar
@onready var DashBar2 = $DashBar2 as TextureProgressBar
@onready var BeaconLabel = $BeaconInfo/Label
@onready var TurrentLabel = $TurretInfo/Label
@onready var ClockLabel = $Time
@onready var CurrencyLabel = $Currency/Label
@onready var AmmoSprite = $Ammo/Sprite2D
@onready var AmmoLabel = $Ammo/Label

func UpdateLevelUpExperience(level: int, nextLevelExperience: int):
	XpBar.max_value = nextLevelExperience
	
func UpdateExperience(xp: int):
	XpBar.value = xp

func UpdateHealthBar(stats: CharacterStats):
	HealthBar.max_value = stats.MaxHealth
	HealthBar.value = stats.Health
	DashBar1.value = stats.DashCharge
	DashBar2.value = stats.DashCharge
	BeaconLabel.text = str(stats.BeaconCount)
	TurrentLabel.text = str(stats.TurretCount)

func UpdateTime(seconds, min):
	ClockLabel.text = str(min).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
func UpdateAquiredCurrency(currency):
	CurrencyLabel.text = str(currency)
	
func UpdateAmmoAndSprite(resource, scale, ammo):
	AmmoSprite.texture = resource
	AmmoSprite.scale = Vector2(2.5, 2.5)
	AmmoLabel.text = str(ammo)

func UpdateAmmo(ammo):
	AmmoLabel.text = str(ammo)
