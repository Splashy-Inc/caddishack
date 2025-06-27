extends Button

class_name ShopButton

@export var item_info : MaterialInfo

@onready var material_slot: Marker2D = $SubViewport/MaterialSlot
@onready var price_label: Label = $PanelContainer/PriceLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_item_info(item_info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_item_info(info: MaterialInfo):
	item_info = info
	
	for material in material_slot.get_children():
		material.queue_free()
	
	if item_info:
		material_slot.add_child(Globals.generate_material(item_info))
		price_label.text = str(item_info.price)
