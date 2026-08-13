extends ShopItemInfo

class_name ShopAbilityInfo

@export var ability : AbilityInfo

func get_icon():
	icon = ability.icon
	return icon

func get_active_icon():
	active_icon = ability.active_icon
	return active_icon

func get_item_name():
	item_name = ability.name
	return item_name

func get_base_cost():
	return base_cost

func get_description():
	description = ability.description
	return description
