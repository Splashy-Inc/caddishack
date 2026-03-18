extends Node

signal main_menu_requested
signal pause_menu_requested
signal how_to_requested
signal win_screen_requested
signal loss_screen_requested
signal hide_menus_requested

signal start_pressed(scene: PackedScene)
signal resume_pressed
signal restart_pressed
signal back_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("pause"):
		pause_menu_requested.emit()
