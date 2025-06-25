extends StaticBody2D

class_name BeadMaterial

@export var info : MaterialInfo
@onready var bodies: Node2D = $Bodies
@onready var sand_body: SandBody = $Bodies/SandBody
@onready var pearl_body: Node2D = $Bodies/PearlBody
@onready var shell_body: Node2D = $Bodies/ShellBody
@onready var jimmie_body: Node2D = $Bodies/JimmieBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_body()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_body():
	if not is_node_ready():
		await ready
	for child in get_children():
		if child != bodies:
			child.queue_free()
	
	var target_body : Node2D
	if info is SandMaterialInfo:
		target_body = sand_body
		sand_body.set_color(info.color)
	elif info is SpecialMaterialInfo:
		match info.type:
			SpecialMaterialInfo.SpecialType.PEARL:
				target_body = pearl_body
			SpecialMaterialInfo.SpecialType.SHELL:
				target_body = shell_body
			SpecialMaterialInfo.SpecialType.JIMMIE:
				target_body = jimmie_body
	
	for child in target_body.get_children():
		var child_copy = child.duplicate()
		add_child(child_copy)
