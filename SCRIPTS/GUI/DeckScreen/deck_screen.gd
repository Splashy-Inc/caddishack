extends PanelContainer

class_name DeckScreen

@onready var deck_view: DeckView = $HBoxContainer/VBoxContainer/DeckView
@onready var ability_laser_view: AbilityLaserView = $HBoxContainer/AbilityLaserView

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ability_added_to_card(larva_card: LarvaCard) -> void:
	await get_tree().create_timer(.25).timeout
	deck_view.add_card(larva_card)
	await get_tree().create_timer(.25).timeout
	ScreenEvents.request_screen(ScreenEvents.Screen.SHOP)
