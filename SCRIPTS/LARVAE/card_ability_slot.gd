extends HBoxContainer

class_name CardAbilitySlot

@onready var icon: TextureRect = $Icon
@onready var name_label: Label = $Name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_ability_info(new_info: AbilityInfo):
	icon.texture = new_info.icon
	name_label.text = new_info.name

func clear():
	icon.texture = null
	name_label.text = ""
