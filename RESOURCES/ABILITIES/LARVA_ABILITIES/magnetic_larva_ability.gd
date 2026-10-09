extends LarvaAbilityInfo

class_name MagneticLarvaAbility

## Enables the [param magnetic] property of [param larva] to pull in nearby materials
func apply_ability(larva: Larva):
	larva.magnetic = true
