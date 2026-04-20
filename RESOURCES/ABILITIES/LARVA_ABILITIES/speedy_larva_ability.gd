extends LarvaAbilityInfo

class_name SpeedyLarvaAbility

@export_custom(PROPERTY_HINT_NONE, "suffix:%") var percent_change : int

## Increases [param larva]'s [param speed_mod] by ability's [param percent] per [param num_stacks].
## Should only be used once.
func apply_ability(larva: Larva):
	if _apply_ability():
		larva.speed_mod += larva.speed_mod * (percent_change/100.0 * num_stacks)
