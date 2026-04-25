extends PanelContainer

class_name AbilityLaserView

signal ability_added_to_card(larva_card)

@onready var ability_item: ShopItem = $VBoxContainer/LaserSpace/Center/Laser/AbilitySlot/AbilityItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_petri_dish_larva_added(larva: Larva) -> void:
	if ability_item.info is ShopAbilityInfo:
		larva.add_ability(ability_item.info.ability)

func _on_petri_dish_larva_card_added(larva_card: LarvaCard) -> void:
	if ability_item.info is ShopAbilityInfo:
		larva_card.add_ability(ability_item.info.ability)
	
	ability_added_to_card.emit(larva_card)
