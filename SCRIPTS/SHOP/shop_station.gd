extends Station

class_name ShopStation

@export var available_items: Array[MaterialInfo]
@onready var cart: CartPanel = $PanelContainer/ShopHBox/CartPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	available_items = available_items.duplicate()
	for button in get_tree().get_nodes_in_group("shop_buttons"):
		if button is ShopButton:
			button.set_item_info(available_items.pop_front())
			button.pressed.connect(_on_shop_item_selected.bind(button.item_info))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_shop_item_selected(item_info: MaterialInfo):
	cart.add_material(item_info.duplicate())

func _on_cart_panel_checkout_pressed(materials: Array[MaterialInfo], current_money: int) -> void:
	for material_info in materials:
		if not material_info in Globals.run_info.terrarium.materials:
			Globals.run_info.terrarium.materials.append(material_info)
	Globals.run_info.money = current_money
	won.emit(self)

func load_run_info():
	cart.reset_cart()
	cart.set_current_money(Globals.run_info.money)
