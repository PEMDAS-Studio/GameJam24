extends CanvasLayer
class_name GameOverlay

@onready var HealthBar = $HealthBar as TextureProgressBar

func UpdateHealthBar(stats: CharacterStats):
	HealthBar.max_value = stats.MaxHealth
	HealthBar.value = stats.Health
