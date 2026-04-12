extends Station

class_name ShopStation

@export var terrariums : Array[Terrarium]
@export var terrarium_buttons : Array[Button]
@onready var next_button: Button = $NextButton
@onready var terrarium_zoom_point: ZoomPoint = $TerrariumZoomPoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize_terrariums()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_next_button_pressed() -> void:
	for button in terrarium_buttons:
		if button.button_pressed:
			RunEvents.set_current_terrarium_info(terrariums[terrarium_buttons.find(button)].info)
	ScreenEvents.request_screen(ScreenEvents.Screen.TERRARIUM)

func randomize_terrariums():
	for terrarium in terrariums:
		terrarium.randomize_materials()

func _on_reroll_button_pressed() -> void:
	randomize_terrariums()

func _on_terrarium_button_pressed(source_button: Button) -> void:
	for button in terrarium_buttons:
		var terrarium = terrariums[terrarium_buttons.find(button)]
		if button != source_button:
			terrarium.toggle_travel(true)
			terrarium_zoom_point.dezoom_node(terrarium)
			button.button_pressed = false
		else:
			terrarium.toggle_travel(false)
			terrarium_zoom_point.zoom_node(terrarium)
			next_button.disabled = false
