extends Node2D

class_name Bead

signal clicked

@export var info : BeadInfo
var travel_target_global_position : Vector2
var travel_target_rotation : float
var is_travelling := false

@onready var sand_sprite: AnimatedSprite2D = $SandSprite
@onready var item_sprite: AnimatedSprite2D = $ItemSprite
@onready var clickable_shape: CollisionShape2D = $ClickableArea/ClickableShape

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
	info = new_info
	sand_sprite.animation = SandMaterialInfo.SandColor.keys()[info.sand.color]
	item_sprite.animation = SpecialMaterialInfo.SpecialType.keys()[info.special.type]

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
