extends PanelContainer

class_name LarvaInfoPanel

@export var wombo_combo_descriptor_scene : PackedScene
@export var ability_descriptor_scene : PackedScene

@export var larva : Larva
@onready var tab_container: TabContainer = $HBoxContainer/VBoxContainer/TabContainer

func _ready() -> void:
	set_larva_info(larva.info)
	CardEvents.card_clicked.connect(_on_card_clicked)
	pass

func _on_close_button_pressed() -> void:
	hide()

func set_larva_info(new_info: LarvaInfo):
	larva.set_info(new_info)
	
	var tabs_to_clear : Array
	for i in tab_container.get_tab_count():
		tabs_to_clear.append(tab_container.get_tab_control(i))
	for tab in tabs_to_clear:
		tab.free()
	
	if larva.info.base_abilities.front() is WomboComboBaseAbilityInfo:
		tab_container.add_child(wombo_combo_descriptor_scene.instantiate())
	
	for i in larva.info.abilities.size():
		tab_container.add_child(ability_descriptor_scene.instantiate())
	
	for i in tab_container.get_tab_count():
		var descriptor = tab_container.get_tab_control(i)
		if descriptor is WomboComboDescriptor:
			descriptor.load_ability(larva.info.base_abilities.front())
			tab_container.set_tab_title(i, "Wombo Combo")
			continue
		elif descriptor is AbilityDescriptor:
			if i - 1 < larva.info.abilities.size():
				descriptor.load_ability(larva.info.abilities[i - 1])
				tab_container.set_tab_title(i, "")
				tab_container.set_tab_icon(i, larva.info.abilities[i - 1].icon_medium)

func _on_card_clicked(larva_card: LarvaCard, button_index: MouseButton):
	set_larva_info(larva_card.larva.info)
	show()
