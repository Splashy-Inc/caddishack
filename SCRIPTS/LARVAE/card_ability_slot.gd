extends Button

class_name CardAbilitySlot

var ability_info : AbilityInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_ability_info(new_info: AbilityInfo):
	ability_info = new_info
	icon = new_info.icon
	text = new_info.name

func clear():
	icon = null
	text = ""
