extends CharacterBody2D

class_name Larva

signal died(caddis_fly: Larva)

const SPEED = 100.0

var speed_mod := 1.0
var direction : Vector2

var bead_completed := false

@export var egg_info : EggMaterialInfo

@export var bead : Bead

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bead_center: Marker2D = $BeadCenter
@onready var bead_bar: TextureProgressBar = $BeadBar
@onready var bug_body: AnimatedSprite2D = $BugBody

var material_queue : Array[MaterialInfo]

func _ready() -> void:
	if bead:
		bead.completed.connect(_on_bead_completed)
	#bead_bar.value = 0
	update_type()

func _physics_process(delta: float) -> void:
	if not (bead_completed or (animation_player.assigned_animation == "collect" and animation_player.is_playing())):
		var new_direction = Vector2.ZERO
		
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

func die():
	bead.position = Vector2.ZERO
	bead.reparent(bead_center, false)
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
	bead_completed = true
	animation_player.play("retract")

func initialize(new_egg_info: EggMaterialInfo):
	egg_info = new_egg_info
	update_type()
	
func update_type():
	if bug_body:
		bug_body.play(EggMaterialInfo.EggType.keys()[egg_info.type])
