extends PanelContainer

class_name DeckScreen

@export var deck_view: DeckView
@export var ability_laser_view: AbilityLaserView
@export var info : DeckScreenInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(new_info: DeckScreenInfo):
	if not is_node_ready():
		await ready
	
	info = new_info
	
	if is_instance_valid(new_info.deck):
		for larva_info in new_info.deck.get_sorted_larvae():
			deck_view.add_card(Globals.generate_card(larva_info), true)
	
	if is_instance_valid(new_info.ability_info):
		ability_laser_view.load_ability(new_info.ability_info)
		ability_laser_view.show()
	else:
		ability_laser_view.hide()

func _on_ability_laser_view_card_completed(larva_card: LarvaCard, success: bool) -> void:
	await get_tree().create_timer(.25).timeout
	deck_view.add_card(larva_card)
	if success:
		# TODO: Probably a better way to do this, but good enough for now!
		info.shop_info.items[info.shop_info.items.find(info.ability_info)] = null
		await get_tree().create_timer(.25).timeout
		ScreenEvents.request_screen(ScreenEvents.Screen.SHOP, info.shop_info)

func _on_cancel_button_pressed() -> void:
	ScreenEvents.request_screen(ScreenEvents.Screen.SHOP, info.shop_info)
