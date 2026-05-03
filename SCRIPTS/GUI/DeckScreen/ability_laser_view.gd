extends PanelContainer

class_name AbilityLaserView

signal card_completed(larva_card: LarvaCard, success: bool)

@export var ability_item: ShopItem
@export var petri_dish: PetriDish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_ability(info: ShopAbilityInfo):
	ability_item.load_info(info)

func _on_petri_dish_larva_added(larva: Larva) -> void:
	if ability_item.info is ShopAbilityInfo:
		larva.add_ability(ability_item.info.ability)

func _on_petri_dish_larva_card_added(larva_card: LarvaCard) -> void:
	if is_instance_valid(ability_item):
		if ability_item.info is ShopAbilityInfo:
			if larva_card.add_ability(ability_item.info.ability):
				ability_item.queue_free()
				card_completed.emit(larva_card, true)
			else:
				card_completed.emit(larva_card, false)

func _on_ability_item_load_info_completed(success: bool) -> void:
	petri_dish.toggle_enabled(success)
	if success:
		show()
	else:
		hide()
