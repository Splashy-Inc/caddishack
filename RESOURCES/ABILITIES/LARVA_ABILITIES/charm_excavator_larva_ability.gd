extends LarvaAbilityInfo

class_name CharmExcavatorLarvaAbility

@export var charm_type : SpecialMaterialInfo.SpecialType

## Sets a larva's [param dig_type] to trigger a charm spawn when collecting a spade
func apply_ability(larva: Larva):
	if charm_type != SpecialMaterialInfo.SpecialType.BASIC:
		larva.dig_type = charm_type
