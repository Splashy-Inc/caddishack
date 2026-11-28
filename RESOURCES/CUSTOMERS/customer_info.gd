extends Resource

class_name CustomerInfo

@export var sprite_frames : SpriteFrames
@export var materials : Array[MaterialInfo]
@export var effect := {
	EffectType.POINTS: 0,
	EffectType.MULT: 0,
	EffectType.VOUCHERS: 0,
} as Dictionary[EffectType, int]

enum EffectType {
	POINTS,
	MULT,
	VOUCHERS,
}

func calculate_bonus(bead_info: BeadInfo, effect_type: EffectType) -> int:
	var bonus := 0
	var is_match := true
	for material in materials:
		if material is SandMaterialInfo:
			for color in material.colors:
				if not color in bead_info.sand.colors:
					is_match = false
					break
		elif material is SpecialMaterialInfo:
			if material.type != bead_info.special.type:
				is_match = false
				break
	
	if is_match:
		bonus += effect[effect_type]
	return bonus
