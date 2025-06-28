extends Node2D

class_name BraceletContainer

@export var bracelets : Array[BraceletInfo]

@onready var bracelet_slots: Node2D = $BraceletSlots


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_bracelets(bracelets)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fill_bracelets(new_bracelets: Array[BraceletInfo]):
	clear_bracelets()
	var temp_bracelets = new_bracelets.duplicate()
	for slot in bracelet_slots.get_children():
		for child in slot.get_children():
			if child is Bracelet:
				if not temp_bracelets.is_empty():
					var new_bracelet = temp_bracelets.pop_front() as BraceletInfo
					child.set_beads(new_bracelet.bead_array_info)
	bracelets = new_bracelets

func add_bracelet(new_bracelet: Bracelet):
	var new_bracelet_info = BraceletInfo.new()
	for bead in new_bracelet.get_beads():
		if bead is Bead:
			new_bracelet_info.bead_array_info.beads.append(bead.info.duplicate())
	bracelets.append(new_bracelet_info.duplicate())
	new_bracelet.clear_beads()
	fill_bracelets(bracelets)

func clear_bracelets():
	for slot in bracelet_slots.get_children():
		for child in slot.get_children():
			if child is Bracelet:
				child.set_beads(BeadArrayInfo.new())
