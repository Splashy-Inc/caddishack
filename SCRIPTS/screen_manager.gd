extends Node

class_name ScreenManager

var cur_screen_scene: PackedScene

@onready var hud: HUD = $HUD

var screen: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	HUDEvents.main_menu_requested.connect(_on_screen_requested)
	HUDEvents.main_menu_requested.emit()
	ScreenEvents.screen_requested.connect(_on_screen_requested)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_screen_requested(screen_scene: PackedScene = null):
	if screen:
		screen.queue_free()
	
	if screen_scene == null and is_instance_valid(cur_screen_scene):
		screen_scene = cur_screen_scene
	
	if is_instance_valid(screen_scene):
		var new_screen = screen_scene.instantiate()
		add_child(new_screen)
		
		screen = new_screen
		HUDEvents.hide_menus_requested.emit()
