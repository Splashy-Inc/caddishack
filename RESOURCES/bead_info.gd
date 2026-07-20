extends Resource

class_name BeadInfo

@export var abilities : Array[BeadAbilityInfo]
@export var sand := SandMaterialInfo.new()
@export var special := SpecialMaterialInfo.new()

const VALUE_BREAKDOWN_STRUCT := {
	"color_points" : 0,
	"charm_mult" : 0,
	"point_abilities" : {
	},
	"mult_abilities" : {
	},
}

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

func get_value_breakdown(bead_array_info: BeadArrayInfo) -> Dictionary:
	var value_breakdown = VALUE_BREAKDOWN_STRUCT.duplicate_deep()
	
	if sand.color != SandMaterialInfo.SandColor.COLORLESS:
		value_breakdown["color_points"] = 1
	if special.type != SpecialMaterialInfo.SpecialType.BASIC:
		value_breakdown["charm_mult"] = 1
		
	for ability in abilities:
		if ability is BeadColorAbilityInfo:
			value_breakdown["point_abilities"][ability] = ability.use_ability(self, bead_array_info.get_beads())
		elif ability is BeadCharmAbilityInfo:
			value_breakdown["mult_abilities"][ability] = ability.use_ability(self, bead_array_info.get_beads())
	return value_breakdown

func add_ability(ability: BeadAbilityInfo):
	if not ability in abilities:
		abilities.append(ability)

func clear_abilities():
	abilities.clear()
