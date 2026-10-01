extends PanelContainer

class_name LarvaInfoPanel

@export var larva : Larva
@onready var ability_descriptor: AbilityDescriptor = $HBoxContainer/VBoxContainer/AbilityDescriptor
@onready var tab_container: TabContainer = $HBoxContainer/VBoxContainer/TabContainer

func _ready() -> void:
	set_larva_info(larva.info)
	pass

func _on_close_button_pressed() -> void:
	hide()

func set_larva_info(new_info: LarvaInfo):
	larva.set_info(new_info)
	for i in tab_container.get_tab_count():
		var descriptor = tab_container.get_tab_control(i)
		if descriptor is WomboComboDescriptor:
			descriptor.load_ability(larva.info.base_abilities.front())
		elif descriptor is AbilityDescriptor:
			if i - 1 < larva.info.abilities.size():
				descriptor.load_ability(larva.info.abilities[i - 1])
				tab_container.set_tab_icon(i, larva.info.abilities[i - 1].icon_medium)
