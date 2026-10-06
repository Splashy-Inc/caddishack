extends PanelContainer

class_name BeadInfoPanel

@export var wombo_combo_descriptor_scene : PackedScene
@export var ability_descriptor_scene : PackedScene

@export var bead : Bead
@onready var tab_container: TabContainer = $HBoxContainer/VBoxContainer/TabContainer
@onready var name_label: Label = $HBoxContainer/VBoxContainer/NamePanel/NameLabel

@export var info_panels: Array[Control]

func _ready() -> void:
	set_bead_info(bead.info)
	BeadEvents.bead_clicked.connect(_on_bead_clicked)

func _on_close_button_pressed() -> void:
	hide()

func set_bead_info(new_info: BeadInfo):
	bead.set_info(new_info, true)
	
	var tabs_to_clear : Array
	for i in tab_container.get_tab_count():
		tabs_to_clear.append(tab_container.get_tab_control(i))
	for tab in tabs_to_clear:
		tab.free()
	
	if not bead.info.base_abilities.is_empty():
		if bead.info.base_abilities.front() is WomboComboBaseAbilityInfo:
			tab_container.add_child(wombo_combo_descriptor_scene.instantiate())
	
	for i in bead.info.abilities.size():
		tab_container.add_child(ability_descriptor_scene.instantiate())
	
	for i in tab_container.get_tab_count():
		var descriptor = tab_container.get_tab_control(i)
		if descriptor is WomboComboDescriptor:
			descriptor.load_ability(bead.info.base_abilities.front())
			tab_container.set_tab_title(i, "Wombo Combo")
			continue
		elif descriptor is AbilityDescriptor:
			if i - 1 < bead.info.abilities.size():
				descriptor.load_ability(bead.info.abilities[i - 1])
				tab_container.set_tab_title(i, "")
				tab_container.set_tab_icon(i, bead.info.abilities[i - 1].icon_medium)

func _on_bead_clicked(new_bead: Bead):
	if not visible or new_bead.info != bead.info:
		for panel in info_panels:
			if panel.visible:
				hide()
				return
		set_bead_info(new_bead.info)
		show()
	else:
		hide()
