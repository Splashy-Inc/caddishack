extends Resource

class_name BeadInfo

@export var sand := SandMaterialInfo.new()
@export var special := SpecialMaterialInfo.new()

# TODO: Factor in modifiers/abilities
func calculate_points(bead_array_info: BeadArrayInfo):
	var points = 0
	if sand.color != SandMaterialInfo.SandColor.COLORLESS:
		points += 1
	return points

# TODO: Factor in modifiers/abilities
func calculate_mult(bead_array_info: BeadArrayInfo):
	var mult = 0
	if special.type != SpecialMaterialInfo.SpecialType.BASIC:
		mult += 1
	return mult
