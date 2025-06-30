extends Button

class_name ShopButton

@export var item_info : MaterialInfo

@onready var material_slot: Marker2D = $SubViewport/MaterialSlot
@onready var price_label: Label = $PanelContainer/PriceLabel
@onready var item_info_box: ItemInfoBox = $ItemInfoBox

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
	
	var new_item_info := ItemInfo.new()
	if item_info is SandMaterialInfo:
		new_item_info.name = "SAND"
		new_item_info.description = "A bead component enabling mult chains in bracelets"
		new_item_info.labels = ["Color"]
		new_item_info.values = [SandMaterialInfo.SandColor.keys()[item_info.color]]
	elif item_info is SpecialMaterialInfo:
		new_item_info.name = SpecialMaterialInfo.SpecialType.keys()[item_info.type]
		new_item_info.description = "A high point bead component enabling mult chains in bracelets"
		new_item_info.labels = ["Points"]
		new_item_info.values = [str(Bracelet.SPECIAL_POINTS)]
	elif item_info is EggMaterialInfo:
		new_item_info.name = EggMaterialInfo.EggType.keys()[item_info.type] + " EGG"
		match item_info.type:
			EggMaterialInfo.EggType.BASIC:
				new_item_info.description = "Hatches a larva with no special abilities"
			EggMaterialInfo.EggType.SANDY:
				new_item_info.description = "Hatches a larva that knows the location of all sand"
			EggMaterialInfo.EggType.GOED:
				new_item_info.description = "Hatches a larva that knows the location of all materials"
	
	item_info_box.set_item_info(new_item_info)
