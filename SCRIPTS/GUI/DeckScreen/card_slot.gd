extends PanelContainer

class_name CardSlot

@onready var center: Control = $CardFrame/Center

var larva_card : LarvaCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_for_card()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_card(new_card: LarvaCard) -> bool:
	if not check_for_card():
		if is_instance_valid(new_card.get_parent()):
			new_card.reparent(center, false)
		else:
			center.add_child(new_card)
			#new_card.position = Vector2.ZERO
		
		larva_card = new_card
		larva_card.position = Vector2.ZERO
		return true
	
	return false

func check_for_card():
	if not larva_card in center.get_children():
		larva_card = null
	
	for child in center.get_children():
		if not is_instance_valid(larva_card):
			if child is LarvaCard:
				larva_card = child
				continue
		
		if child != larva_card:
			child.queue_free()
	
	return is_instance_valid(larva_card)
