extends CharacterBody2D

class_name Larva

signal died(larva: Larva)

const SPEED = 100.0

var speed_mod := 1.0
var direction : Vector2

var larva_scene := preload("res://SCENES/TERRARIUM/larva.tscn")

@export var bead : Bead

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var collection_area: Area2D = $CollectionArea

var material_queue : Array[MaterialInfo]

var bead_completed := false
var target : Node2D
var can_move : bool
var making_bead := false
@export var lifespan_sec := 0

@export var info : LarvaInfo
@export var ability_icons : Array[TextureRect]

## TODO: Remove when we can change larva abilities in-game
@export var proto_abilities : Array[AbilityInfo]

func _ready() -> void:
	if bead:
		bead.completed.connect(_on_bead_completed)
	set_lifespan(lifespan_sec)
	update_type()
	# TODO: Remove this once we are able to edit larva abilities in game
	# Random spread of prototype abilities
	for i in proto_abilities.size():
		if randi_range(0, 1):
			info.add_ability(proto_abilities[i].duplicate())
	load_abilities()

func _physics_process(delta: float) -> void:
		target = _get_closest_target()
		can_move = making_bead and not (bead_completed or (animation_player.assigned_animation == "collect" and animation_player.is_playing()))
		if can_move:
			direction = _get_direction()
			
			if direction != Vector2.ZERO:
				animation_player.play("move")
			else:
				animation_player.play("idle")
			
			navigation_agent.max_speed = SPEED * speed_mod
			navigation_agent.set_velocity(direction * SPEED * speed_mod)

func die():
	bead.reparent(get_parent())
	died.emit(self)

func _on_died(larva: Larva) -> void:
	larva.queue_free()

func _on_collection_area_body_entered(body: Node2D) -> void:
	if body is BeadMaterial:
		if body.info is SandMaterialInfo:
			if bead.info.sand.color == SandMaterialInfo.SandColor.COLORLESS:
				material_queue.append(body.info)
				body.queue_free()
				animation_player.play("collect")
		
		if body.info is SpecialMaterialInfo:
			if bead.info.special.type == SpecialMaterialInfo.SpecialType.BASIC:
				material_queue.append(body.info)
				body.queue_free()
				animation_player.play("collect")

func place_material_from_queue():
	var material_to_place = material_queue.pop_front()
	if material_to_place is SandMaterialInfo:
		bead.set_color(material_to_place.color)
	elif material_to_place is SpecialMaterialInfo:
		bead.set_special(material_to_place.type)

func _on_bead_completed():
	if animation_player.current_animation == "collect" and animation_player.is_playing():
		await animation_player.animation_finished
	bead_completed = true
	animation_player.play("retract")

func initialize():
	pass
	
func update_type():
	pass

func _get_direction() -> Vector2:
	var direction = Vector2.ZERO
	if target:
		if navigation_agent.target_position != target.global_position:
			navigation_agent.set_target_position(target.global_position)
	else:
		navigation_agent.set_target_position(global_position)
	if not navigation_agent.is_target_reached():
		direction = global_position.direction_to(navigation_agent.get_next_path_position())
	return direction

func _get_closest(nodes: Array) -> Node2D:
	if nodes.is_empty():
		return null
	else:
		var closest_node
		for node in nodes:
			if node is SandMaterial:
				if bead.has_sand_color():
					continue
			else:
				if bead.has_charm():
					continue
			if not closest_node or global_position.distance_to(node.global_position) < global_position.distance_to(closest_node.global_position):
				closest_node = node
		return closest_node

func _get_closest_target():
	return _get_closest(get_tree().get_nodes_in_group("materials"))

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if can_move:
		velocity = safe_velocity
		rotation = lerpf(rotation, -velocity.angle_to(Vector2.UP), .1)
		move_and_slide()

func set_lifespan(seconds: int):
	lifespan_sec = seconds
	if bead and making_bead:
		bead.set_completion_time(lifespan_sec)

func start_making_bead():
	collection_area.monitoring = true
	making_bead = true
	set_lifespan(lifespan_sec)

func load_abilities():
	bead.clear_abilities()
	
	for i in ability_icons.size():
		if i < info.abilities.size():
			var ability = info.abilities[i]
			ability_icons[i].texture = ability.icon
			if ability is LarvaAbilityInfo:
				ability.apply_ability(self)
			elif ability is BeadAbilityInfo:
				bead.info.add_ability(ability)
				bead.load_abilities()
		else:
			ability_icons[i].texture = null
