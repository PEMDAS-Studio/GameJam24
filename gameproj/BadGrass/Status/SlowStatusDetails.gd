extends StatusDetails
class_name SlowStatusDetails

func Init(duration, chanceOfEffect, slowPercentage) -> SlowStatusDetails:
	Duration = duration
	ChanceOfEffect = chanceOfEffect
	SlowPercentage = slowPercentage
	return self

var Duration : float
var ChanceOfEffect: float
var SlowPercentage : float
