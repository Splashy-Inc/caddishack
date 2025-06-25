extends CharacterBody2D

class_name CaddisFly

signal died(caddis_fly: CaddisFly)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var speed_mod := 1.0
var direction : Vector2

@export var bead : Bead
@export var camera : Camera2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bead_center: Marker2D = $BeadCenter
@onready var bead_bar: TextureProgressBar = $BeadBar
@onready var lifespan_timer: Timer = $LifespanTimer

var material_queue : Array[MaterialInfo]

func _ready() -> void:
	if bead:
		bead.completed.connect(_on_bead_completed)
	bead_bar.max_value = lifespan_timer.wait_time
	bead_bar.value = 0

func _physics_process(delta: float) -> void:
	bead_bar.value = lifespan_timer.wait_time - lifespan_timer.time_left
	if not (lifespan_timer.is_stopped() or (animation_player.assigned_animation == "collect" and animation_player.is_playing())):
		var new_direction = Vector2.ZERO
		if Globals.is_mobile and Globals.joystick:
			new_direction = Globals.joystick.direction
		else:
			new_direction = Input.get_vector("left", "right", "up", "down")
		
		if new_direction and new_direction != Vector2.ZERO:
			speed_mod = 1.0
			direction = direction.lerp(new_direction.normalized(), .1)
			animation_player.play("move")
			rotation = -direction.angle_to(Vector2.UP)
		else:
			speed_mod = 0.0
			animation_player.play("idle")
			
		velocity = direction * SPEED * speed_mod
			
		move_and_slide()

func _on_lifespan_timer_timeout() -> void:
	animation_player.play("retract")

func die():
	died.emit(self)

func _on_died(caddis_fly: CaddisFly) -> void:
	camera.reparent(caddis_fly.get_parent())
	bead.position = Vector2.ZERO
	bead.reparent(caddis_fly.bead_center, false)
	bead.reparent(caddis_fly.get_parent())
	caddis_fly.queue_free()

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
	lifespan_timer.stop()
	animation_player.play("retract")
