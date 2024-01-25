extends StatusDetails
class_name FearStatusDetails

func Init(duration, chanceOfEffect) -> FearStatusDetails:
	Duration = duration
	ChanceOfEffect = chanceOfEffect
	return self

var Duration : float
var ChanceOfEffect: float
