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

func _ready() -> void:
	bead_bar.max_value = lifespan_timer.wait_time
	bead_bar.value = 0

func _physics_process(delta: float) -> void:
	bead_bar.value = lifespan_timer.wait_time - lifespan_timer.time_left
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
			if bead.set_color(body.info.color):
				body.queue_free()
		
		if body.info is SpecialMaterialInfo:
			if bead.set_special(body.info.type):
				body.queue_free()
