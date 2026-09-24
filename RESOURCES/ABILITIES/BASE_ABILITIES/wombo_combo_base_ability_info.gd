extends BaseAbilityInfo

class_name WomboComboBaseAbilityInfo

@export var color : SandMaterialInfo.SandColor
@export var charm : SpecialMaterialInfo.SpecialType

var sand_weights : Dictionary[SandMaterialInfo.SandColor, int] = {
	SandMaterialInfo.SandColor.CYAN: 100,
	SandMaterialInfo.SandColor.MAGENTA: 100,
	SandMaterialInfo.SandColor.YELLOW: 100,
}

var charm_weights : Dictionary[SpecialMaterialInfo.SpecialType, int] = {
	SpecialMaterialInfo.SpecialType.PEARL: 100,
	SpecialMaterialInfo.SpecialType.SHELL: 100,
	SpecialMaterialInfo.SpecialType.JIMMIE: 100,
	SpecialMaterialInfo.SpecialType.HEART: 50,
	SpecialMaterialInfo.SpecialType.SPADE: 50,
}

func use_ability(origin_bead_info: BeadInfo, bead_info_set: Array[BeadInfo]):
	var bonus_base_multiplier = 0
	
	if color in origin_bead_info.sand.colors and charm == origin_bead_info.special.type:
		bonus_base_multiplier = 1
	
	return bonus_base_multiplier

func randomize_combo():
	var rng := RandomNumberGenerator.new()
	color = sand_weights.keys()[rng.rand_weighted(sand_weights.values())]
	charm = charm_weights.keys()[rng.rand_weighted(charm_weights.values())]
