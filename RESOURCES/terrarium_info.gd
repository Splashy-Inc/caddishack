extends Resource

class_name TerrariumInfo

@export var sand_weights : Dictionary[SandMaterialInfo.SandColor, int] = {
	SandMaterialInfo.SandColor.CYAN: 100,
	SandMaterialInfo.SandColor.MAGENTA: 100,
	SandMaterialInfo.SandColor.YELLOW: 100,
}
@export var charm_weights : Dictionary[SpecialMaterialInfo.SpecialType, int] = {
	SpecialMaterialInfo.SpecialType.PEARL: 100,
	SpecialMaterialInfo.SpecialType.SHELL: 100,
	SpecialMaterialInfo.SpecialType.JIMMIE: 100,
	SpecialMaterialInfo.SpecialType.HEART: 50,
	SpecialMaterialInfo.SpecialType.SPADE: 50,
}
const MAX_NUM_MATERIALS := 20
@export var base_min_sand := 5
@export var base_min_charm := 5

@export var materials : Array[MaterialInfo]

func randomize_materials(num_sand : int = base_min_sand, num_charm : int = base_min_charm) -> Array[MaterialInfo]:
	var rng := RandomNumberGenerator.new()
	var new_materials : Array[MaterialInfo]
	num_sand += randi_range(0, MAX_NUM_MATERIALS - num_sand - num_charm)
	num_charm += MAX_NUM_MATERIALS - num_sand - num_charm
	for i in num_sand:
		var new_sand := SandMaterialInfo.new()
		new_sand.add_color(sand_weights.keys()[rng.rand_weighted(sand_weights.values())])
		new_materials.append(new_sand)
	
	for i in num_charm:
		var new_charm := SpecialMaterialInfo.new()
		new_charm.type = charm_weights.keys()[rng.rand_weighted(charm_weights.values())]
		new_materials.append(new_charm)
	
	materials = new_materials
	
	return materials
