extends PanelContainer

class_name AbilityDescriptor

@onready var icon: TextureRect = $TopHalf/Icon
@onready var name_label: Label = $TopHalf/Info/Name
@onready var description: Label = $TopHalf/Info/Description
@onready var stacks: HBoxContainer = $TopHalf/Info/Stacks
@onready var num_stacks: Label = $TopHalf/Info/Stacks/NumStacks
@onready var max_stacks: Label = $TopHalf/Info/Stacks/MaxStacks

func load_ability(new_ability: AbilityInfo):
	if not is_node_ready():
		await ready
	icon.texture = new_ability.icon
	name_label.text = new_ability.name
	description.text = new_ability.long_description
	stacks.visible = new_ability.num_stacks > 0
	num_stacks.text = str(new_ability.num_stacks)
	max_stacks.text = str(new_ability.max_stacks)
