extends Resource
class_name CharacterStatEffect

@export var Dduration : float
@export var Name : String

func ApplyEffect(character: Character):
	pass 

func ResetEffect(character: Character):
	character._effects.erase(self)
	
func UpdateEffect(character: Character):
	pass
