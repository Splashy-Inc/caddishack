extends PanelContainer

class_name DeckScreen

@export var deck_view: DeckView
@export var ability_laser_view: AbilityLaserView

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(deck: DeckInfo, info: ShopAbilityInfo = null):
	if not is_node_ready():
		await ready
	
	if is_instance_valid(deck):
		for larva_info in deck.get_sorted_larvae():
			deck_view.add_card(Globals.generate_card(larva_info), true)
	
	if is_instance_valid(info):
		ability_laser_view.load_ability(info)
		ability_laser_view.show()
	else:
		ability_laser_view.hide()

func _on_ability_laser_view_card_completed(larva_card: LarvaCard, success: bool) -> void:
	await get_tree().create_timer(.25).timeout
	deck_view.add_card(larva_card)
	if success:
		await get_tree().create_timer(.25).timeout
		ScreenEvents.request_screen(ScreenEvents.Screen.SHOP)
