extends BeadCharmAbilityInfo

## Bonus mult for collecting the right charm
class_name CharmAffinityBeadAbility

@export var charm_type : SpecialMaterialInfo.SpecialType
@export var mult_bonus := 5

## Generate bonus mult if the bead's charm matches [param charm_type] 
func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]) -> int:
	var bonus_mult := 0
	
	if origin_bead_info.special.type == charm_type:
		bonus_mult = mult_bonus
	
	return bonus_mult
