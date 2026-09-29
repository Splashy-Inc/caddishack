extends PanelContainer

class_name LarvaInfoPanel

@export var larva : Larva
@onready var clickable_abilities: ClickableAbilities = $HBoxContainer/LarvaDescriptor/VBoxContainer/VBoxContainer/ClickableAbilities
@onready var ability_descriptor: AbilityDescriptor = $HBoxContainer/VBoxContainer/AbilityDescriptor

func _ready() -> void:
	#ability_descriptor.visible = clickable_abilities.load_abilities(larva.info.abilities)
	pass

func _on_close_button_pressed() -> void:
	hide()
