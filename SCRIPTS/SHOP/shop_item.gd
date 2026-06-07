extends Button

class_name ShopItem

signal load_info_completed(success: bool)

@export var info : ShopItemInfo
@export var in_shop : bool

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var icon_space: PanelContainer = $ItemSpace/TopHalf/IconSpace
@onready var icon_sprite: Sprite2D = $ItemSpace/TopHalf/IconSpace/Center/Icon
@onready var name_label: Label = $ItemSpace/TopHalf/TopRightSpace/Name
@onready var cost_label: Label = $ItemSpace/TopHalf/TopRightSpace/Cost
@onready var description_label: Label = $ItemSpace/Description



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_info(info)
	RunEvents.score_updated.connect(check_disabled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	if not disabled:
		animation_player.play("highlight")

func _on_mouse_exited() -> void:
	animation_player.play("RESET")

func load_info(new_info: ShopItemInfo):
	if is_instance_valid(new_info):
		if not is_node_ready():
			await ready
		info = new_info
		
		icon_sprite.texture = info.get_icon()
		icon_sprite.scale = Vector2(1,1) * icon_space.size.x/icon_sprite.texture.get_size().x
		name_label.text = info.get_item_name()
		cost_label.text = "$" + str(info.get_base_cost())
		description_label.text = info.get_description()
		check_disabled()
		load_info_completed.emit(true)
		show()
	else:
		load_info_completed.emit(false)
		hide()

func check_disabled(new_score: int = 0):
	disabled = info.get_base_cost() > RunEvents.get_score()
