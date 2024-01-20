extends CanvasLayer
class_name GameOverlay

@onready var HealthBar = $HealthBar as TextureProgressBar
@onready var XpBar = $ExperienceBar as TextureProgressBar

func UpdateLevelUpExperience(level: int, nextLevelExperience: int):
	XpBar.max_value = nextLevelExperience
	
func UpdateExperience(xp: int):
	XpBar.value = xp

func UpdateHealthBar(stats: CharacterStats):
	HealthBar.max_value = stats.MaxHealth
	HealthBar.value = stats.Health
