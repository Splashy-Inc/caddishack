extends StaticBody2D

class_name PetriDish

signal larva_added(added_larva: Larva)
signal larva_card_added(added_card : LarvaCard)

@onready var larva_slot: Marker2D = $LarvaSlot
@export var collision_shape: CollisionShape2D

var larva : Larva
var larva_card : LarvaCard

@onready var lazer_zap: AnimatedSprite2D = $LazerZap

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
	if not check_for_card():
		if new_larva_card.get_parent():
			new_larva_card.reparent(self, false)
		else:
			add_child(new_larva_card)
		new_larva_card.toggle_larva_view(true)
		
		new_larva_card.position += larva_slot.position
		larva_card = new_larva_card
		larva = larva_card.larva
		larva_card_added.emit(larva_card)
		return true
	
	return false

func check_for_card():
	if not larva_card in get_children():
		larva_card = null
	
	for child in get_children():
		if not is_instance_valid(larva_card):
			if child is LarvaCard:
				larva_card = child
				continue
	
	return is_instance_valid(larva_card)

func toggle_enabled(is_enabled: bool):
	collision_shape.disabled = not is_enabled

func zap_larva():
	lazer_zap.play("zap")
