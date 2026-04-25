extends ScrollContainer

class_name DeckView

@export var card_slot_scene : PackedScene
@export var larva_card_scene : PackedScene

@onready var deck_grid: GridContainer = $DeckGrid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while add_card(larva_card_scene.instantiate()):
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card(larva_card: LarvaCard) -> bool:
	for slot in deck_grid.get_children():
		if slot is CardSlot:
			if slot.add_card(larva_card):
				return true
	
	return false
