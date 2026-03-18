extends Node

signal screen_requested(screen_scene: PackedScene)
signal pause_toggled(is_paused: bool, mouse_mode: Input.MouseMode)

# TODO: Preload actual scene files (ideally UID) here
var main_screens := {
	"shop": PackedScene.new(),
	"terrarium": PackedScene.new(),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
