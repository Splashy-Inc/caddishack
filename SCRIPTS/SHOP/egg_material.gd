extends BeadMaterial

class_name EggMaterial

signal hatched(larva: CaddisFly, spawn_point: Vector2)

const SPEED = 500

var is_hatched := false

@onready var top: RigidBody2D = $Top
@onready var top_sprites: AnimatedSprite2D = $Top/Sprites
@onready var top_screen_notifier: VisibleOnScreenNotifier2D = $Top/VisibleOnScreenNotifier2D

@onready var bottom: RigidBody2D = $Bottom
@onready var bottom_sprites: AnimatedSprite2D = $Bottom/Sprites
@onready var bottom_screen_notifier: VisibleOnScreenNotifier2D = $Bottom/VisibleOnScreenNotifier2D

func _material_ready():
	if info is EggMaterialInfo:
		top_sprites.play(EggMaterialInfo.EggType.keys()[info.type])
		bottom_sprites.play(EggMaterialInfo.EggType.keys()[info.type])
	
	top_screen_notifier.screen_exited.connect(_on_egg_half_screen_exited.bind(top))
	bottom_screen_notifier.screen_exited.connect(_on_egg_half_screen_exited.bind(bottom))

func _physics_process(delta: float) -> void:
	if is_hatched and not (get_top() or get_bottom()):
		queue_free()

func spawn_larva() -> CaddisFly:
	var new_larva := Globals.generate_larva()
	new_larva.initialize(info)
	is_hatched = true
	top.apply_impulse(Vector2.UP * SPEED)
	bottom.apply_impulse(Vector2.DOWN * SPEED)
	hatched.emit(new_larva, global_position)
	return new_larva

func get_top():
	if is_instance_valid(top):
		return top
	else:
		return null

func get_bottom():
	if is_instance_valid(bottom):
		return bottom
	else:
		return null

func _on_egg_half_screen_exited(egg_half: RigidBody2D) -> void:
	if is_hatched:
		egg_half.queue_free()
