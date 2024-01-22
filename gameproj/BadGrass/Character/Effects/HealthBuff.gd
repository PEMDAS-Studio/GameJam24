extends CharacterStatEffect
class_name HealthBuff

@export var IncreasePercentage : float = 0
var Description : String = "Increase the Character Max Health by " + str(IncreasePercentage)

func ApplyEffect(character: Character):
	var buffTimer = Timer.new()
	buffTimer.one_shot = true
	buffTimer.wait_time = Dduration
	buffTimer.timeout.connect(ResetEffect.bind(character))
	var healthIncrease = character.Stats.MaxHealth * IncreasePercentage / 100
	character.Stats.MaxHealth += healthIncrease
	character.Stats.Health += healthIncrease
	character.add_child(buffTimer)
	buffTimer.start()

func ResetEffect(character: Character):
	character.Stats.MaxHealth = character.Stats.OriginalHeath
	super.ResetEffect(character)
	
func UpdateEffect(character: Character):
	character.Stats.MaxHealth += character.Stats.OriginalHeath * IncreasePercentage
