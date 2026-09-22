extends VBoxContainer

class_name AbilitiesTab

@export var ability_descriptor_scene : PackedScene
@onready var grid_container: GridContainer = $ScrollContainer/GridContainer

func _ready() -> void:
	clear()
	
	for ability in RunEvents.get_unlocked_abilities():
		var new_ability_descriptor = ability_descriptor_scene.instantiate() as AbilityDescriptor
		new_ability_descriptor.load_ability(ability)
		grid_container.add_child(new_ability_descriptor)

func clear():
	for child in grid_container.get_children():
		child.queue_free()
