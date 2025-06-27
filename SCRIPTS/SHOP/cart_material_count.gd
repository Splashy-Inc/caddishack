extends VBoxContainer

class_name CartMaterialCount

signal item_pressed(material_info: MaterialInfo)

@export var material_info : MaterialInfo
var total := 0

@onready var material_slot: Marker2D = $CartItem/SubViewport/MaterialSlot
@onready var count: Label = $HBox/Count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_material_info(material_info)
	set_count(total)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_material_info(new_info: MaterialInfo):
	material_info = new_info
	
	for material in material_slot.get_children():
		if material is BeadMaterial:
			material.queue_free()
	
	if material_info:
		material_slot.add_child(Globals.generate_material(material_info))

func set_count(new_count: int):
	total = new_count
	count.text = str(total)

func _on_cart_item_pressed() -> void:
	item_pressed.emit(material_info)
