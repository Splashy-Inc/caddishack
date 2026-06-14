extends Resource

class_name ShopInfo

@export var items : Array[ShopItemInfo]
@export var terrariums : Array[TerrariumInfo]
@export var selected_terrarium := -1

func _ready():
	ShopEvents.item_purchased.connect(_on_item_purchased)

func _on_item_purchased(info : ShopItemInfo):
	for item in items:
		if item == info:
			item = null
