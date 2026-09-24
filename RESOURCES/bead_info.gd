extends Resource

class_name BeadInfo

@export var abilities : Array[BeadAbilityInfo]
@export var base_abilities : Array[BaseAbilityInfo]
@export var sand := SandMaterialInfo.new()
@export var special := SpecialMaterialInfo.new()

const VALUE_BREAKDOWN_STRUCT := {
	"color_points" : 0,
	"charm_mult" : 0,
	"abilities" : {},
	"base_abilities" : {},
}

const ABILITY_BREAKDOWN_STRUCT := {
	"value" : 0,
	"affected_beads" : [],
}

func calculate_points(bead_array_info: BeadArrayInfo):
	var points = calculate_color_points()
	
	for ability in abilities:
		if ability is BeadColorAbilityInfo:
			points += ability.use_ability(self, bead_array_info.get_beads())
	
	return points

func calculate_color_points():
	return sand.get_unique_colors().size()

func calculate_mult(bead_array_info: BeadArrayInfo):
	var mult = 0
	if special.type != SpecialMaterialInfo.SpecialType.BASIC:
		mult += 1
	
	for ability in abilities:
		if ability is BeadCharmAbilityInfo:
			mult += ability.use_ability(self, bead_array_info.get_beads())
	
	return mult

func calculate_base_multiplier(bead_array_info: BeadArrayInfo):
	var base_multiplier = 1

	for ability in base_abilities:
		base_multiplier += ability.use_ability(self, bead_array_info.get_beads())
	
	return base_multiplier

func get_value_breakdown(bead_array_info: BeadArrayInfo) -> Dictionary:
	var value_breakdown = VALUE_BREAKDOWN_STRUCT.duplicate_deep()
	
	value_breakdown["color_points"] += calculate_color_points()
	if special.type != SpecialMaterialInfo.SpecialType.BASIC:
		value_breakdown["charm_mult"] = 1
		
	for ability in abilities:
		value_breakdown["abilities"][ability] = ABILITY_BREAKDOWN_STRUCT.duplicate_deep()
		value_breakdown["abilities"][ability]["value"] = ability.use_ability(self, bead_array_info.get_beads())
		value_breakdown["abilities"][ability]["affected_beads"] = ability.get_affected_beads(self, bead_array_info.get_beads())
	
	for ability in base_abilities:
		value_breakdown["base_abilities"][ability] = ABILITY_BREAKDOWN_STRUCT.duplicate_deep()
		value_breakdown["base_abilities"][ability]["value"] = ability.use_ability(self, bead_array_info.get_beads())
		value_breakdown["base_abilities"][ability]["affected_beads"] = ability.get_affected_beads(self, bead_array_info.get_beads())
	
	return value_breakdown

func add_ability(ability: BeadAbilityInfo):
	if ability is BaseAbilityInfo:
		if not ability in base_abilities:
			base_abilities.append(ability)
	if not ability in abilities:
		abilities.append(ability)

func clear_abilities():
	abilities.clear()
	base_abilities.clear()
