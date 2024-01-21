extends Resource
class_name BaseWeaponEffect

var Name : String
var Description: String
var EffectLevels : Array[StatusDetails]
var EffectDetail : StatusDetails 
var Level : int 

func ApplyEffect(target) -> bool:
	return false

func BuildDescription():
	pass
