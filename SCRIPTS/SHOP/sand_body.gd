extends Node2D

class_name SandBody

@onready var sprites: AnimatedSprite2D = $Sprites

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_color(new_color: SandMaterialInfo.SandColor):
	sprites.play(SandMaterialInfo.SandColor.keys()[new_color])
