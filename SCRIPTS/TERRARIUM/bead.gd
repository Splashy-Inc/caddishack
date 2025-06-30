extends Node2D

class_name Bead

signal clicked
signal completed

@export var info : BeadInfo
var travel_target_global_position : Vector2
var travel_target_rotation : float
var is_travelling := false

@onready var sand_sprite: AnimatedSprite2D = $SandSprite
@onready var item_sprite: AnimatedSprite2D = $ItemSprite
@onready var clickable_shape: CollisionShape2D = $ClickableArea/ClickableShape
@onready var item_info_box: ItemInfoBox = $ItemInfoBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_info(BeadInfo.new())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_travelling:
		if global_position.distance_to(travel_target_global_position) < 10:
			global_position = travel_target_global_position
			rotation = travel_target_rotation
			scale = Vector2(1.0, 1.0)
			is_travelling = false
		else:
			global_position = global_position.lerp(travel_target_global_position, .25)
			rotation = lerpf(rotation, travel_target_rotation, .25)
			scale = scale.lerp(Vector2(1.0, 1.0), .25)

func initialize(new_info: BeadInfo):
	if not is_node_ready():
		await ready
	set_info(new_info)

func set_clickable(new_clickable: bool):
	clickable_shape.disabled = not new_clickable

func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("select"):
		clicked.emit()

func travel_to(target_global_position: Vector2, target_scale: Vector2 = Vector2(1.0,1.0), target_rotation: float = 0.0):
	travel_target_global_position = target_global_position
	scale = target_scale
	travel_target_rotation = target_rotation
	is_travelling = true

func set_info(new_info: BeadInfo):
	if info.sand.color != new_info.sand.color:
		set_color(new_info.sand.color)
	
	if info.special.type != new_info.special.type:
		set_special(new_info.special.type)
	
	var item_info := ItemInfo.new()
	item_info.name = "BEAD"
	item_info.description = "Combine beads to make a bracelet"
	item_info.labels = ["Color", "Special", "Points"]
	item_info.values = [SandMaterialInfo.SandColor.keys()[info.sand.color], SpecialMaterialInfo.SpecialType.keys()[info.special.type], str(get_points())]
	
	item_info_box.set_item_info(item_info)

func set_color(new_color: SandMaterialInfo.SandColor) -> bool:
	if info.sand.color == SandMaterialInfo.SandColor.COLORLESS or new_color == SandMaterialInfo.SandColor.COLORLESS:
		info.sand.color = new_color
		sand_sprite.play(SandMaterialInfo.SandColor.keys()[info.sand.color])
		check_completed()
		return true
	return false

func set_special(new_special_type: SpecialMaterialInfo.SpecialType) -> bool:
	if info.special.type == SpecialMaterialInfo.SpecialType.BASIC or new_special_type == SpecialMaterialInfo.SpecialType.BASIC:
		info.special.type = new_special_type
		item_sprite.play(SpecialMaterialInfo.SpecialType.keys()[info.special.type])
		check_completed()
		return true
	return false

func check_completed():
	if info.sand.color != SandMaterialInfo.SandColor.COLORLESS and info.special.type != SpecialMaterialInfo.SpecialType.BASIC:
		completed.emit()

func get_points():
	var points = 0
	match info.special.type:
		SpecialMaterialInfo.SpecialType.BASIC:
			points += 1
		_:
			points += 3
	
	return points
