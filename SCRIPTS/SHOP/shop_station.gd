extends Station

class_name ShopStation

@export var available_items: Array[MaterialInfo]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in get_tree().get_nodes_in_group("shop_buttons"):
		if button is ShopButton:
			button.set_item_info(available_items.pop_front())
			button.pressed.connect(_on_shop_item_selected.bind(button.item_info))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_shop_item_selected(item_info: MaterialInfo):
	print("Item selected: ", item_info, " ", item_info.price)
