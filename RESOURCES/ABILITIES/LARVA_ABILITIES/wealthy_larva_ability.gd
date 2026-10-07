extends LarvaAbilityInfo

class_name WealthyLarvaAbility

@export_custom(PROPERTY_HINT_NONE, "suffix:%") var percent_score : int
@export var uses := 1

## When initially applied [percent_score]% of quota to score, one per larva
## Worth a lot
## One time use (takes up a slot forever)
func apply_ability(larva: Larva):
	if uses > 0:
		RunEvents.change_score(percent_score/100.0 * RunEvents.get_quota())
		uses -= 1
