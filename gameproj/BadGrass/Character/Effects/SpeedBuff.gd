extends CharacterStatEffect
class_name SpeedBuff

@export var IncreasePercentage : float = 0
var Description : String = "Increase the Character Speed by " + str(IncreasePercentage)

func ApplyEffect(character: Character):
	var buffTimer = Timer.new()
	buffTimer.one_shot = true
	buffTimer.wait_time = Dduration
	buffTimer.timeout.connect(ResetEffect(character))
	character.Stats.Speed += character.Stats.Speed * IncreasePercentage
	character.add_child(buffTimer)
	buffTimer.start()

func ResetEffect(character: Character):
	character.Stats.Speed = character.Stats.OriginalSpeed
	
func UpdateEffect(character: Character):
	pass
