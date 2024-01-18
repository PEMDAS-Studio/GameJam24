extends CharacterStatEffect
class_name RegenBuff

@export var RegenRate : float = 0

var Description : String = "Regenerate the character health by " + str(RegenRate) + " for " + str(Dduration)

func ApplyEffect(character: Character):
	var buffTimer = Timer.new()
	buffTimer.one_shot = true
	buffTimer.wait_time = Dduration
	buffTimer.timeout.connect(RemoveEffect(buffTimer))
	character.add_child(buffTimer)
	
	var regenTimer = Timer.new()
	regenTimer.one_shot = false
	regenTimer.wait_time = 1
	regenTimer.timeout.connect(Heal(character))
	buffTimer.add_child(regenTimer)
	buffTimer.start()
	regenTimer.start()

func Heal(character: Character):
	character.Stats.Health += RegenRate

func RemoveEffect(timer: Timer):
	timer.queue_free()
