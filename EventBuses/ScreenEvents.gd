extends Node

signal screen_requested(screen_scene: PackedScene)
signal pause_toggled(is_paused: bool, mouse_mode: Input.MouseMode)

enum Screen {
	SHOP,
	TERRARIUM,
}

var screen_scenes := {
	Screen.SHOP: preload("uid://b4x5r54x0yddx"),
	Screen.TERRARIUM: preload("uid://2tvle0b4ckdc"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func request_screen(screen_id: Screen):
	match screen_id:
		Screen.SHOP:
			RunEvents.round_started.emit()
	screen_requested.emit(screen_scenes[screen_id])
