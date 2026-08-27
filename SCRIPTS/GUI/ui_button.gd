extends Button

class_name UIButton

@export var hover_sound_scene: PackedScene = preload("uid://b541wyt8ubmd7")
@export var press_sound_scene: PackedScene = preload("uid://dsismqget8078")

var hover_sound := AudioStreamPlayer.new()
var press_sound := AudioStreamPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if hover_sound_scene:
		hover_sound = hover_sound_scene.instantiate()
	if press_sound_scene:
		press_sound = press_sound_scene.instantiate()
	add_child(hover_sound)
	add_child(press_sound)
	
	pressed.connect(play_pressed_sound)
	mouse_entered.connect(play_hover_sound)
	_button_ready()

# To be overridden by child to handle any ready event things while retaining above behavior
func _button_ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_pressed_sound():
	if is_instance_valid(press_sound):
		press_sound.play()

func play_hover_sound():
	if is_instance_valid(hover_sound) and not disabled:
		hover_sound.play()
