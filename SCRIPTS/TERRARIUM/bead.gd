extends Node2D

class_name Bead

signal clicked
signal completed

@export var info : BeadInfo
var travel_target_global_position : Vector2
var travel_target_rotation : float
var is_travelling := false

@export var allowed_sand_colors = 1

@export var completion_time := 1
@export var complete := true

@export var sand_sprites : Array[AnimatedSprite2D]

@onready var item_sprite: AnimatedSprite2D = $ItemSprite
@onready var clickable_shape: CollisionShape2D = $ClickableArea/ClickableShape
@onready var animation_tree: AnimationTree = $AnimationPlayer/AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BeadEvents.bead_color_highlight_toggle_requested.connect(_on_color_highlight_toggle_requested)
	BeadEvents.bead_charm_highlight_toggle_requested.connect(_on_charm_highlight_toggle_requested)
	set_completion_time(completion_time)
	info = info.duplicate(true)
	set_info(info)
	load_abilities()

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
	if new_info == null:
		new_info = BeadInfo.new()
	new_info = new_info.duplicate(true)
	if not info.sand.has_same_colors(new_info.sand):
		set_sand(new_info.sand)
	
	if info.special.type != new_info.special.type:
		set_special(new_info.special.type)

func set_sand(new_sand: SandMaterialInfo):
	info.sand = new_sand

func add_color(new_color: SandMaterialInfo.SandColor) -> bool:
	if info.sand.add_color(new_color):
		update_sand_sprites(info.sand)
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
	if is_completed():
		completed.emit()

func force_complete():
	complete = true
	check_completed()

func is_completed():
	if is_sand_color_complete() and has_charm():
		complete = true
	return complete

func is_sand_color_complete():
	return info.sand.get_unique_colors().size() >= allowed_sand_colors

func has_charm():
	return info.special.type != null and info.special.type != SpecialMaterialInfo.SpecialType.BASIC

func get_points() -> int:
	return info.get_points()

func get_mult() -> int:
	return info.get_mult()

func set_completion_time(seconds: float):
	completion_time = seconds
	var timescale = 1.0
	if completion_time > 0:
		timescale /= completion_time
	else:
		timescale = 0
	animation_tree.set("parameters/incomplete/timescaled/TimeScale/scale", timescale)
	animation_tree.get("parameters/playback").travel("incomplete")

func load_abilities():
	for ability in info.abilities:
		ability.apply_ability(self)

func clear_abilities():
	info.clear_abilities()

func toggle_color_highlight(is_highlighted: bool):
	for sand_sprite in sand_sprites:
		sand_sprite.material.set_shader_parameter("on", is_highlighted)
	
func toggle_charm_highlight(is_highlighted: bool):
	item_sprite.material.set_shader_parameter("on", is_highlighted)

func _on_color_highlight_toggle_requested(bead_info: BeadInfo, is_highlighted: bool):
	if bead_info == info:
		toggle_color_highlight(is_highlighted)

func _on_charm_highlight_toggle_requested(bead_info: BeadInfo, is_highlighted: bool):
	if bead_info == info:
		toggle_charm_highlight(is_highlighted)

func update_sand_sprites(sand_info: SandMaterialInfo):
	for i in sand_sprites.size():
		if i < sand_info.get_unique_colors().size():
			sand_sprites[i].set_animation(SandMaterialInfo.SandColor.keys()[sand_info.get_unique_colors()[i]])
		else:
			sand_sprites[i].set_animation(SandMaterialInfo.SandColor.keys()[SandMaterialInfo.SandColor.COLORLESS])
