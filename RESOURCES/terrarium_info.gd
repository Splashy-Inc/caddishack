extends Resource

class_name TerrariumInfo

@export var sand_weights : Dictionary[SandMaterialInfo.SandColor, int] = {
	SandMaterialInfo.SandColor.CYAN: 1,
	SandMaterialInfo.SandColor.MAGENTA: 1,
	SandMaterialInfo.SandColor.YELLOW: 1,
}
@export var charm_weights : Dictionary[SpecialMaterialInfo.SpecialType, int] = {
	SpecialMaterialInfo.SpecialType.PEARL: 1,
	SpecialMaterialInfo.SpecialType.SHELL: 1,
	SpecialMaterialInfo.SpecialType.JIMMIE: 1,
}

@export var base_num_sand := 10
@export var base_num_charm := 10

@export var materials : Array[MaterialInfo]

func randomize_materials(num_sand : int = base_num_sand, num_charm : int = base_num_charm) -> Array[MaterialInfo]:
	var rng := RandomNumberGenerator.new()
	var new_materials : Array[MaterialInfo]
	for i in num_sand:
		var new_sand := SandMaterialInfo.new()
		new_sand.color = sand_weights.keys()[rng.rand_weighted(sand_weights.values())]
		new_materials.append(new_sand)
	
	for i in num_charm:
		var new_charm := SpecialMaterialInfo.new()
		new_charm.type = charm_weights.keys()[rng.rand_weighted(charm_weights.values())]
		new_materials.append(new_charm)
	
	materials = new_materials
	
	return materials
