extends StaticBody2D

class_name BeadMaterial

@export var info : MaterialInfo
@export var highlight_enabled_sprite : Node2D
var collected := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_material_ready()

func _material_ready():
	pass

func toggle_highlight(is_highlighted: bool):
	highlight_enabled_sprite.material.set_shader_parameter("on", is_highlighted)
