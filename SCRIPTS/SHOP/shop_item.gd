extends Button

class_name ShopItem

@export var info : ShopItemInfo

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon_sprite: Sprite2D = $ItemSpace/TopHalf/IconSpace/Icon
@onready var name_label: Label = $ItemSpace/TopHalf/TopRightSpace/Name
@onready var cost_label: Label = $ItemSpace/TopHalf/TopRightSpace/Cost
@onready var description_label: Label = $ItemSpace/Description

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_info(info)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	animation_player.play("highlight")

func _on_mouse_exited() -> void:
	animation_player.play("RESET")

func load_info(new_info: ShopItemInfo):
	info = new_info
	icon_sprite.texture = info.icon
	name_label.text = info.name
	cost_label.text = str(info.base_cost)
	description_label.text = info.description

func _on_pressed() -> void:
	ShopEvents.purchase_item(info)
