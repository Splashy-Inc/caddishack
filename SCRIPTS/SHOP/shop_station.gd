extends Station

class_name ShopStation

@export var terrariums : Array[Terrarium]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize_terrariums()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_next_button_pressed() -> void:
	ScreenEvents.request_screen(ScreenEvents.Screen.TERRARIUM)

func randomize_terrariums():
	for terrarium in terrariums:
		terrarium.randomize_materials()
