extends Button

@export var scene_to_start : PackedScene
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var press_sound: AudioStreamPlayer = $PressSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	press_sound.play()
	RunEvents.reset_run()
	var random_terrarium = TerrariumInfo.new()
	random_terrarium.randomize_materials()
	RunEvents.set_current_terrarium_info(random_terrarium)
	ScreenEvents.request_screen(ScreenEvents.Screen.TERRARIUM)


func _on_mouse_entered() -> void:
	hover_sound.play()
