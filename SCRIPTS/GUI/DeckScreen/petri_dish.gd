extends StaticBody2D

class_name PetriDish

@onready var larva_slot: Marker2D = $LarvaSlot

var larva : Larva

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_larva(new_larva: Larva):
	if not is_instance_valid(larva):
		if new_larva.get_parent():
			new_larva.reparent(larva_slot, false)
		else:
			larva_slot.add_child(new_larva)
		larva = new_larva
		return true
	
	return false
