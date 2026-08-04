extends LarvaAbilityInfo

class_name ResourcefulLarvaAbility

## Allows a larva to add color to their bed without taking the material from the terrarium
func apply_ability(larva: Larva):
	larva.exhaust_material = false
