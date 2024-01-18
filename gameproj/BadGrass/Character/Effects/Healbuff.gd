extends CharacterStatEffect

@export var HealAmount : float = 0
var Description : String = "Heal the character by " + str(HealAmount)

func ApplyEffect(character: Character):
	character.Stats.Health += HealAmount
