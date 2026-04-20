extends Resource

class_name BeadInfo

@export var abilities : Array[BeadAbilityInfo]
@export var sand := SandMaterialInfo.new()
@export var special := SpecialMaterialInfo.new()

func calculate_points(bead_array_info: BeadArrayInfo):
	var points = 0
	if sand.color != SandMaterialInfo.SandColor.COLORLESS:
		points += 1
	
	for ability in abilities:
		if ability is BeadColorAbilityInfo:
			points += ability.use_ability(self, bead_array_info.get_beads())
	
	return points

func calculate_mult(bead_array_info: BeadArrayInfo):
	var mult = 0
	if special.type != SpecialMaterialInfo.SpecialType.BASIC:
		mult += 1
	
	for ability in abilities:
		if ability is BeadCharmAbilityInfo:
			mult += ability.use_ability(self, bead_array_info.get_beads())
	
	return mult

func add_ability(ability: BeadAbilityInfo):
	if not ability in abilities:
		abilities.append(ability)

func clear_abilities():
	abilities.clear()
