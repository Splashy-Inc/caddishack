extends Sprite2D

class_name BeadSlot

@onready var slot_center: Marker2D = $SlotCenter

@export var ability_icons : Array[Sprite2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_icons()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_abilities(abilities: Array[BeadAbilityInfo]):
	reset_icons()
	for i in ability_icons.size():
		if i < abilities.size():
			ability_icons[i].texture = abilities[i].icon
			ability_icons[i].show()
		else:
			ability_icons[i].texture = null
			ability_icons[i].hide()

func reset_icons():
	for icon in ability_icons:
		icon.texture = null
		icon.hide()

func has_bead():	
	return slot_center.get_child_count() > 0

func add_bead(new_bead: Bead):
	if not has_bead():
		if new_bead.get_parent():
			new_bead.reparent(slot_center)
		else:
			slot_center.add_child(new_bead)
		
		load_abilities(new_bead.info.abilities)
		return true
	return false

func get_bead() -> Bead:
	if slot_center.get_child_count() > 0:
		return slot_center.get_children().front()
	return null
