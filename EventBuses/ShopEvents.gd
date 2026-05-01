extends Node

signal item_purchased(item_info: ShopItemInfo)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func purchase_item(item_info: ShopItemInfo) -> bool:
	if item_info.base_cost <= RunEvents.get_score():
		RunEvents.change_score(-item_info.base_cost)
		item_purchased.emit(item_info)
		return true
	else:
		return false
