extends AnimatedSprite2D

@export var parent : BeadMaterial

var cur_larva : CaddisFly

var camera : Camera2D
var viewport_rect : Rect2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	viewport_rect = get_viewport_rect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not camera:
		var camera_nodes = get_tree().get_nodes_in_group("camera")
		for node in camera_nodes:
			if node is Camera2D:
				camera = node
				break
	
	if (camera and is_instance_valid(camera)) and (parent and is_instance_valid(parent)):
		if cur_larva and is_instance_valid(cur_larva):
			if parent.info is SandMaterialInfo and (cur_larva.egg_info.type == EggMaterialInfo.EggType.SANDY or cur_larva.egg_info.type == EggMaterialInfo.EggType.GOED):
				visible = true
			elif parent.info is SpecialMaterialInfo and cur_larva.egg_info.type == EggMaterialInfo.EggType.GOED:
				visible = true
			else:
				visible = false
		else:
			for larva in get_tree().get_nodes_in_group("larvae"):
				if larva is CaddisFly and is_instance_valid(larva):
					cur_larva = larva
					break
		
		if parent.info is SandMaterialInfo:
			play(SandMaterialInfo.SandColor.keys()[parent.info.color])
		elif parent.info is SpecialMaterialInfo:
			play(SpecialMaterialInfo.SpecialType.keys()[parent.info.type])
		
		global_position = parent.global_position
		
		var x_distance_limit = viewport_rect.size.x/2 - (16 * scale.x)
		global_position.x = clamp(global_position.x, camera.global_position.x - x_distance_limit, camera.global_position.x + x_distance_limit)
		
		var y_distance_limit = viewport_rect.size.y/2 - (16 * scale.y)
		global_position.y = clamp(global_position.y, camera.global_position.y - y_distance_limit, camera.global_position.y + y_distance_limit)
