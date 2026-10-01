extends BeadMaterial

class_name SandMaterial

@onready var sprites: AnimatedSprite2D = $Sprites
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _material_ready() -> void:
	if info is SandMaterialInfo:
		set_color(info.get_unique_colors(true).front())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_color(new_color: SandMaterialInfo.SandColor):
	if info is SandMaterialInfo:
		info.reset_colors()
		info.add_color(new_color)
	else:
		info = SandMaterialInfo.new()
	
	if not info.get_unique_colors().is_empty():
		sprites.play(SandMaterialInfo.SandColor.keys()[info.get_unique_colors().front()])

func disable():
	if not is_node_ready():
		await ready
	remove_from_group("materials")
	collision_shape_2d.disabled = true
