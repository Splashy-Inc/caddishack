extends PanelContainer

class_name WomboComboDescriptor

@onready var sand_slot: Marker2D = $TopHalf/Icon/Control/SandSlot
@onready var charm_slot: Marker2D = $TopHalf/Icon/Control/CharmSlot
@onready var name_label: Label = $TopHalf/Info/Name
@onready var description: Label = $TopHalf/Info/Description

func load_ability(new_ability: WomboComboBaseAbilityInfo):
	if not is_node_ready():
		await ready
	
	for child in sand_slot.get_children():
		child.queue_free()
		
	for child in charm_slot.get_children():
		child.queue_free()
	
	if new_ability is WomboComboBaseAbilityInfo:
		var color_material_info = SandMaterialInfo.new()
		color_material_info.add_color(new_ability.color)
		var color = Globals.generate_material(color_material_info)
		color.disable()
		sand_slot.add_child(color)
		
		var charm_material_info = SpecialMaterialInfo.new()
		charm_material_info.type = new_ability.charm
		var charm = Globals.generate_material(charm_material_info)
		charm.disable()
		charm_slot.add_child(charm)
	
	name_label.text = new_ability.name
	description.text = new_ability.long_description
