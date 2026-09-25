extends Resource

class_name ShopItemInfo

@export var icon : Texture2D
@export var active_icon : Texture2D
@export var item_name : String
@export var base_cost : int
@export var description : String

func get_icon():
	return icon

func get_active_icon():
	return active_icon

func get_item_name():
	return item_name

func get_base_cost():
	return base_cost

func get_description():
	return description
