extends Node2D

class_name BraceletContainer

@export var bracelets_info : Array[BraceletInfo]

@onready var bracelet_slots: Node2D = $BraceletSlots


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_bracelets(bracelets_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fill_bracelets(new_bracelets_info: Array[BraceletInfo]):
	clear_bracelets()
	var temp_bracelets_info = new_bracelets_info.duplicate()
	for slot in bracelet_slots.get_children():
		for child in slot.get_children():
			if child is Bracelet:
				if not temp_bracelets_info.is_empty():
					var new_bracelet = temp_bracelets_info.pop_front() as BraceletInfo
					child.set_beads(new_bracelet.bead_array_info.duplicate())
	bracelets_info = new_bracelets_info

func add_bracelet(new_bracelet: Bracelet):
	for slot in bracelet_slots.get_children():
		var old_bracelet = slot.get_child(0)
		if old_bracelet is Bracelet:
			if old_bracelet.get_beads().is_empty():
				old_bracelet.reparent(slot.get_parent())
				if set_bracelet_parent(slot, new_bracelet):
					position_bracelet(new_bracelet)
				break
	
	update_bracelets_info()

func set_bracelet_parent(slot: Node2D, bracelet: Bracelet) -> bool:
	if bracelet.get_parent():
		var old_global_transform = bracelet.global_transform
		bracelet.reparent(slot, false)
		bracelet.global_transform = old_global_transform
	else:
		slot.add_child(bracelet)
	return true

func position_bracelet(bracelet: Bracelet):
	bracelet.travel_to(bracelet.get_parent().global_position)

func clear_bracelets():
	for slot in bracelet_slots.get_children():
		for child in slot.get_children():
			if child is Bracelet:
				child.set_beads(BeadArrayInfo.new())

func get_bracelets() -> Array[Bracelet]:
	var bracelets : Array[Bracelet]
	for slot in bracelet_slots.get_children():
		if slot.get_child(0) is Bracelet:
			bracelets.append(slot.get_child(0))
	return bracelets

func update_bracelets_info():
	var new_bracelets_info : Array[BraceletInfo]
	for bracelet in get_bracelets():
		var new_bracelet_info = BraceletInfo.new()
		for bead in bracelet.get_beads():
			if bead is Bead:
				new_bracelet_info.bead_array_info.beads.append(bead.info.duplicate())
		new_bracelets_info.append(new_bracelet_info.duplicate())
	bracelets_info = new_bracelets_info

func get_bracelets_info():
	update_bracelets_info()
	return bracelets_info
