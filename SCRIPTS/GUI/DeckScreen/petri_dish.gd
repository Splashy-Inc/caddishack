extends StaticBody2D

class_name PetriDish

signal larva_added(added_larva: Larva)

@onready var larva_slot: Marker2D = $LarvaSlot

var larva : Larva
var larva_card : LarvaCard

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
		larva_added.emit(larva)
		return true
	
	return false

func add_larva_card(new_larva_card: LarvaCard):
	if not is_instance_valid(larva):
		if new_larva_card.get_parent():
			new_larva_card.reparent(self, false)
		else:
			add_child(new_larva_card)
		
		new_larva_card.position += larva_slot.position - new_larva_card.larva_slot.position
		larva_card = new_larva_card
		larva = larva_card.larva
		larva_added.emit(larva)
		return true
	
	return false
