extends LarvaAbilityInfo

class_name LongLivedLarvaAbility

@export_custom(PROPERTY_HINT_NONE, "suffix:%") var percent_change : int

## Increases [param larva]'s [param lifespan_mod] by ability's [param percent] per [param num_stacks].
## Should only be used once.
func apply_ability(larva: Larva):
	larva.lifespan_mod += (percent_change/100.0 * num_stacks)
