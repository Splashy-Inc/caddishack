extends LarvaAbilityInfo

class_name GreedyLarvaAbility

## Sets a larva's greedy property to true, making them collect charms first
func apply_ability(larva: Larva):
	larva.greedy = true
