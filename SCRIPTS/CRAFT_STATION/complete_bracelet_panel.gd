extends Node2D

class_name BraceletContainer

@export var bracelets : Array[BraceletInfo]

@onready var bracelet_slots: Node2D = $BraceletSlots


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_bracelets(bracelets)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_bracelets(new_bracelets: Array[BraceletInfo]):
	var temp_bracelets = new_bracelets.duplicate()
	for slot in bracelet_slots.get_children():
		for child in slot.get_children():
			if child is Bracelet:
				if not temp_bracelets.is_empty():
					var new_bracelet = temp_bracelets.pop_front() as BraceletInfo
					child.set_beads(new_bracelet.bead_array_info)
		
