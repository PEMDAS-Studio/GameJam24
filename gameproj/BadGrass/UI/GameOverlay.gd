extends CanvasLayer
class_name GameOverlay

@onready var HealthBar = $HealthBar as TextureProgressBar
@onready var XpBar = $ExperienceBar as TextureProgressBar
@onready var DashBar1 = $DashBar1 as TextureProgressBar
@onready var DashBar2 = $DashBar2 as TextureProgressBar

func UpdateLevelUpExperience(level: int, nextLevelExperience: int):
	XpBar.max_value = nextLevelExperience
	
func UpdateExperience(xp: int):
	XpBar.value = xp

func UpdateHealthBar(stats: CharacterStats):
	HealthBar.max_value = stats.MaxHealth
	HealthBar.value = stats.Health
	DashBar1.value = stats.DashCharge
	DashBar2.value = stats.DashCharge
