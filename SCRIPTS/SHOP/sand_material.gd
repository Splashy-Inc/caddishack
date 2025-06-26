extends BeadMaterial

class_name SandMaterial

@onready var sprites: AnimatedSprite2D = $Sprites

# Called when the node enters the scene tree for the first time.
func _material_ready() -> void:
	if info is SandMaterialInfo:
		sprites.play(SandMaterialInfo.SandColor.keys()[info.color])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_color(new_color: SandMaterialInfo.SandColor):
	sprites.play(SandMaterialInfo.SandColor.keys()[new_color])
