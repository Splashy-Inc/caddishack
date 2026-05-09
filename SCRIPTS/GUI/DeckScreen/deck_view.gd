extends ScrollContainer

class_name DeckView

@export var card_slot_scene : PackedScene
@export var larva_card_scene : PackedScene
@export var test_mode := false

@onready var deck_grid: GridContainer = $DeckGrid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if test_mode:
		while add_card(larva_card_scene.instantiate()):
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card(larva_card: LarvaCard, force_slot: bool = false) -> bool:
	for slot in deck_grid.get_children():
		if slot is CardSlot:
			if slot.add_card(larva_card):
				larva_card.toggle_larva_view(false)
				return true
	
	if force_slot:
		var new_slot = deck_grid.add_slot()
		
	
	return false
