extends Node2D

class_name AbilityIcon

@onready var neutral: Sprite2D = $Neutral
@onready var active: Sprite2D = $Active

var info : AbilityInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_icon()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_icons(ability_info: AbilityInfo):
	reset_icon()
	info = ability_info
	
	if is_instance_valid(ability_info.icon):
		neutral.texture = ability_info.icon.duplicate()
	
	if is_instance_valid(ability_info.active_icon):
		active.texture = ability_info.active_icon.duplicate()

func reset_icon():
	info = null
	neutral.texture = null
	active.texture = null
	toggle_active(false)

func toggle_active(is_active: bool):
	active.visible = is_active
