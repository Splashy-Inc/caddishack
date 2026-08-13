extends MaterialInfo

class_name SandMaterialInfo

enum SandColor {
	COLORLESS,
	CYAN,
	MAGENTA,
	YELLOW,
}

@export var colors := [SandColor.COLORLESS] as Array[SandColor]

func get_unique_colors(include_colorless: bool = false) -> Array[SandColor]:
	var colors_to_return : Array[SandColor]
	for color in colors:
		if not color in colors_to_return:
			if include_colorless or color != SandColor.COLORLESS:
				colors_to_return.append(color)
	return colors_to_return

func add_color(new_color: SandColor, overwrite_colorless: bool = true) -> bool:
	if overwrite_colorless:
		if colors.has(SandColor.COLORLESS) and get_matching_colors([new_color]).is_empty():
			colors[colors.find(SandColor.COLORLESS)] = new_color
		else:
			return false
	else:
		colors.append(new_color)
	
	return true

func has_same_colors(sand_to_compare: SandMaterialInfo) -> bool:
	if colors.size() != sand_to_compare.colors.size():
		return false
	else:
		for color in colors:
			if not color in sand_to_compare.colors:
				return false
	
	return true

func has_matching_color(sand_to_compare: SandMaterialInfo) -> bool:
	if get_matching_colors(sand_to_compare.get_unique_colors()).is_empty():
		return false
	else:
		return true

func get_matching_colors(colors_to_match: Array[SandColor], include_colorless: bool = false) -> Array[SandColor]:
	var matching_colors : Array[SandColor]
	for color in colors_to_match:
		if color in colors and not color in matching_colors:
			matching_colors.append(color)
	return matching_colors

func is_complete():
	for color in colors:
		if color == SandColor.COLORLESS:
			return false
	return true

func reset_colors():
	colors = [SandColor.COLORLESS]
