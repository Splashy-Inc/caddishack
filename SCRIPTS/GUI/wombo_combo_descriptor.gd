extends PanelContainer

class_name WomboComboDescriptor

@onready var icon: TextureRect = $TopHalf/Icon
@onready var name_label: Label = $TopHalf/Info/Name
@onready var description: Label = $TopHalf/Info/Description

func load_ability(new_ability: WomboComboBaseAbilityInfo):
	if not is_node_ready():
		await ready
	#icon.texture = new_ability.icon
	name_label.text = new_ability.name
	description.text = new_ability.long_description
