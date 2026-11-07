extends CharacterBody2D

class_name Larva

signal died(larva: Larva)

const SPEED = 100.0

var speed_mod := 1.0
var direction : Vector2

var larva_scene := preload("res://SCENES/TERRARIUM/larva.tscn")

@export var bead : Bead

@onready var body_animated_sprite: AnimatedSprite2D = $Body
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var collection_area: Area2D = $CollectionArea
@onready var collect_sound: AudioStreamPlayer = $CollectSound
@onready var magnetism_area: Area2D = $MagnetismArea

var material_queue : Array[BeadMaterial]
var material_info_to_place : MaterialInfo

## If true, deletes materials when picking them up 
@export var exhaust_material := true

var bead_completed := false
var target : Node2D
var can_move : bool
var making_bead := false
@export var lifespan_sec := 0
var lifespan_mod := 1.0
@export var magnetic := false
var magnetism_speed := SPEED * .5
var materials_to_magnetize : Array[BeadMaterial]
var greedy := false
var dig_type : SpecialMaterialInfo.SpecialType

@export var info : LarvaInfo
@export var ability_icons : Array[TextureRect]

func _ready() -> void:
	if bead:
		bead.completed.connect(_on_bead_completed)
	set_lifespan(lifespan_sec)
	initialize(info)
	if greedy:
		collection_area.collision_mask = 64
	else:
		collection_area.collision_mask = 32 + 64

func _physics_process(delta: float) -> void:
	if reserve_material_from_queue():
		animation_player.play("collect")
	
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
	
	if magnetic:
		for bead_material in materials_to_magnetize:
			bead_material.global_position += bead_material.global_position.direction_to(global_position) * magnetism_speed * delta

func die():
	bead.reparent(get_parent())
	died.emit(self)

func _on_died(larva: Larva) -> void:
	larva.queue_free()

func _on_collection_area_body_entered(body: Node2D) -> void:
	if body is BeadMaterial:
		if body.info is SandMaterialInfo:
			# Make sure there's a colorless to replace
			if not bead.info.sand.get_matching_colors([SandMaterialInfo.SandColor.COLORLESS]).is_empty():
				# Make sure this color doesn't already exist on this bead
				if not bead.info.sand.has_matching_color(body.info):
					material_queue.append(body)
		
		if body.info is SpecialMaterialInfo:
			if bead.info.special.type == SpecialMaterialInfo.SpecialType.BASIC:
				material_queue.append(body)

func _on_collection_area_body_exited(body: Node2D) -> void:
	if body is BeadMaterial:
		material_queue.erase(body)

func reserve_material_from_queue() -> bool:
	while not material_queue.is_empty():
		if is_instance_valid(material_queue.front()) and not material_queue.front().collected:
			var material_to_place = material_queue.front()
			material_info_to_place = material_to_place.info
			if material_info_to_place is SpecialMaterialInfo:
				if material_info_to_place.type == SpecialMaterialInfo.SpecialType.SPADE:
					if dig_type != SpecialMaterialInfo.SpecialType.BASIC:
						var new_material_info := SpecialMaterialInfo.new()
						new_material_info.type = dig_type
						TerrariumEvents.material_spawn_requested.emit(new_material_info, global_position)
			if exhaust_material:
				material_to_place.collected = true
				material_to_place.remove_from_group("materials")
				material_to_place.remove_from_group("sand")
				material_to_place.remove_from_group("charm")
				material_to_place.queue_free()
			return true
		else:
			material_queue.erase(material_queue.front())
	return false

func place_queued_material():
	if is_instance_valid(material_info_to_place):
		if material_info_to_place is SandMaterialInfo:
			bead.add_color(material_info_to_place.colors.front())
		elif not material_info_to_place is SandMaterialInfo:
			bead.set_special(material_info_to_place.type)

func _on_bead_completed():
	if animation_player.current_animation == "collect" and animation_player.is_playing():
		await animation_player.animation_finished
	bead_completed = true
	animation_player.play("retract")

func initialize(new_info: LarvaInfo):
	if not is_node_ready():
		await ready
	set_info(new_info)

func set_info(new_info: LarvaInfo):
	if new_info == null:
		new_info = LarvaInfo.new()
	info = new_info
	load_abilities()

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
				if bead.is_sand_color_complete() or bead.info.sand.has_matching_color(node.info):
					continue
			else:
				if bead.has_charm():
					continue
			if not closest_node or global_position.distance_to(node.global_position) < global_position.distance_to(closest_node.global_position):
				closest_node = node
		return closest_node

func _get_closest_target():
	if greedy and not bead.has_charm() and get_tree().get_nodes_in_group("charm"):
		collection_area.collision_mask = 64
		return _get_closest(get_tree().get_nodes_in_group("charm"))
	else:
		collection_area.collision_mask = 32 + 64
		return _get_closest(get_tree().get_nodes_in_group("materials"))

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if can_move:
		velocity = safe_velocity
		rotation = lerpf(rotation, -velocity.angle_to(Vector2.UP), .1)
		move_and_slide()

func set_lifespan(seconds: int):
	lifespan_sec = seconds
	if bead and making_bead:
		bead.set_completion_time(lifespan_sec * lifespan_mod)

func start_making_bead():
	collection_area.monitoring = true
	magnetism_area.monitoring = true
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
		else:
			ability_icons[i].texture = null
	
	for ability in info.base_abilities:
		bead.info.add_ability(ability)
	
	bead.load_abilities()

func add_ability(new_ability: AbilityInfo) -> bool:
	if info.add_ability(new_ability):
		load_abilities()
		return true
	
	return false

func set_body_idle():
	var random_index = randi_range(1, 3)
	if not body_animated_sprite.animation.contains("idle"):
		body_animated_sprite.play("idle_" + str(random_index))

func _on_magnetism_area_body_entered(body: Node2D) -> void:
	if body is BeadMaterial and not body in materials_to_magnetize:
		materials_to_magnetize.append(body)

func _on_magnetism_area_body_exited(body: Node2D) -> void:
	materials_to_magnetize.erase(body)
