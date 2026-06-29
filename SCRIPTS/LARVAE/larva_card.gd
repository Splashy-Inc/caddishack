extends Node2D

class_name LarvaCard

signal hover_changed(is_hovered: bool)
signal dropped
signal died

@onready var larva_slot: Area2D = $Container/LarvaSlot
@onready var larva: Larva = $Container/LarvaSlot/Larva
@onready var card: Node2D = $Container/Card
@export var ability_slots : Array[CardAbilitySlot]
@onready var card_view_collision_shape: CollisionShape2D = $Container/ClickableArea/CardViewCollisionShape
@onready var larva_view_collision_shape: CollisionShape2D = $Container/ClickableArea/LarvaViewCollisionShape
@onready var name_label: Label = $Container/Card/Name
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var container: Node2D = $Container

func _ready() -> void:
	load_larva_abilities()
	load_larva_name()

func _process(delta: float) -> void:
	toggle_larva_view(is_larva_view())

func load_from_larva(new_larva: Larva):
	if not is_node_ready():
		await ready
	larva.info = new_larva.info
	new_larva.queue_free()
	load_larva_abilities()
	load_larva_name()

func load_from_larva_info(new_larva_info: LarvaInfo):
	if not is_node_ready():
		await ready
	larva.info = new_larva_info
	load_larva_abilities()
	load_larva_name()

func toggle_larva_view(is_larva: bool):
	card_view_collision_shape.disabled = is_larva
	larva_view_collision_shape.disabled = not is_larva
	
	if is_larva:
		larva.scale /= larva_slot.scale
		unlift()
		card.hide()
	else:
		larva.scale *= larva_slot.scale
		card.show()

func is_larva_view() -> bool:
	return not card.visible

func _on_clickable_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		CardEvents.card_clicked.emit(self, event.button_index)

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
		animation_player.play("lift")

func unlift():
	if container.position != Vector2.ZERO:
		animation_player.play_backwards("lift")

func _on_clickable_area_area_entered(area: Area2D) -> void:
	if area is CardHandler and not is_larva_view():
		hover_changed.emit(true)

func _on_clickable_area_area_exited(area: Area2D) -> void:
	if area is CardHandler and not is_larva_view():
		hover_changed.emit(false)
