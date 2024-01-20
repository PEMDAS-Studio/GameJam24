extends StatusDetails
class_name BurnStatusDetails

func Init(duration, tickRate, chanceOfEffect, damagePerTick) -> BurnStatusDetails:
	Duration = duration
	TickRate = tickRate
	ChanceOfEffect = chanceOfEffect
	DamagePerTick = damagePerTick
	return self

var Duration : float
var TickRate: float
var ChanceOfEffect: float
var DamagePerTick : float
