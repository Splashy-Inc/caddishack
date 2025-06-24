extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var speed_mod := 1.0
var direction : Vector2

@export var bead : Bead

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:	
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
