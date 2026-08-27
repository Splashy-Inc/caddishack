extends Node2D

class_name LarvaCard

signal hover_changed(is_hovered: bool)
signal dropped
signal died

@onready var larva_slot: Area2D = $Container/Front/LarvaSlot
@onready var larva: Larva = $Container/Front/LarvaSlot/Larva
@onready var card: Node2D = $Container/Front/Card
@export var ability_slots : Array[CardAbilitySlot]
@onready var card_view_collision_shape: CollisionShape2D = $Container/Front/ClickableArea/CardViewCollisionShape
@onready var larva_view_collision_shape: CollisionShape2D = $Container/Front/ClickableArea/LarvaViewCollisionShape
@onready var name_label: Label = $Container/Front/Card/Name
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var container: Node2D = $Container
@onready var back: Node2D = $Container/Back
@onready var front: Node2D = $Container/Front
@onready var draw_sound: AudioStreamPlayer = $DrawSound

var original_transform : Transform2D
var target_transform : Transform2D
var travelling := false
var drawn := false

func _ready() -> void:
	load_larva_abilities()
	load_larva_name()

func _process(delta: float) -> void:
	toggle_larva_view(is_larva_view())
	if travelling and target_transform != null:
		if transform.origin.distance_to(target_transform.origin) < 2:
			toggle_travel(false)
			transform = target_transform
			drawn = true
			front.scale.x = 1
			back.scale.x = 0
		else:
			transform = transform.interpolate_with(target_transform, .1)
		
		if not drawn:
			var travel_progress = 1 -  transform.origin.distance_to(target_transform.origin)/original_transform.origin.distance_to(target_transform.origin)
			front.scale.x = clamp(2 * (travel_progress - .5), 0, 1)
			back.scale.x = clamp(2 * (.5 - travel_progress), 0, 1)

func load_from_larva(new_larva: Larva):
	if not is_node_ready():
		await ready
	larva.set_info(new_larva.info)
	new_larva.queue_free()
	load_larva_abilities()
	load_larva_name()

func load_from_larva_info(new_larva_info: LarvaInfo):
	if not is_node_ready():
		await ready
	larva.set_info(new_larva_info)
	load_larva_abilities()
	load_larva_name()

func toggle_larva_view(is_larva: bool):
	card_view_collision_shape.disabled = is_larva
	larva_view_collision_shape.disabled = not is_larva
	
	if is_larva:
		larva.scale /= larva_slot.scale
		unlift()
		card.hide()
		drawn = true
		travelling = false
		front.scale.x = 1
		back.scale.x = 0
	else:
		larva.scale *= larva_slot.scale
		card.show()

func is_larva_view() -> bool:
	return not card.visible

func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			CardEvents.card_pressed.emit(self, event.button_index)
		else:
			CardEvents.card_released.emit(self, event.button_index)

func get_larva() -> Larva:
	return larva

func drop(drop_target):
	if is_instance_valid(drop_target):
		if drop_target.has_method("add_larva_card"):
			if drop_target.add_larva_card(self):
				return true
		elif drop_target.has_method("add_larva"):
			if drop_target.add_larva(larva):
				die()
				return true
	
	return false

func die():
	get_parent().remove_child(self)
	died.emit()

func load_larva_abilities():
	if not larva.is_node_ready():
		await larva.ready
	larva.load_abilities()
	var larva_abilities = larva.info.abilities
	for i in ability_slots.size():
		if i < larva_abilities.size():
			ability_slots[i].load_ability_info(larva_abilities[i])
			ability_slots[i].show()
		else:
			ability_slots[i].clear()

func add_ability(new_ability: AbilityInfo) -> bool:
	if larva.add_ability(new_ability):
		load_larva_abilities()
		return true
	
	return false

func load_larva_name():
	name_label.text = larva.info.name

func lift():
	if container.position == Vector2.ZERO and not is_larva_view():
		if get_parent() is CardHand:
			animation_player.play("lift")

func unlift():
	if container.position != Vector2.ZERO:
		animation_player.play_backwards("lift")

func _on_clickable_area_area_entered(area: Area2D) -> void:
	if area is CardHandler and not is_larva_view() and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		hover_changed.emit(true)

func _on_clickable_area_area_exited(area: Area2D) -> void:
	if area is CardHandler and not is_larva_view():
		hover_changed.emit(false)

func travel_to(new_target_transform: Transform2D):
	if not drawn and not draw_sound.playing:
		draw_sound.play()
	if not travelling:
		original_transform = transform
	toggle_travel(true)
	target_transform = new_target_transform

func toggle_travel(is_travelling: bool):
	travelling = is_travelling

func flip():
	if not is_node_ready():
		await ready
	
	if front.scale.x > .5:
		front.scale.x = 0
		back.scale.x = 1
	else:
		front.scale.x = 1
		back.scale.x = 0
