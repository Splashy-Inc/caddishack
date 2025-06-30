extends Area2D

@export var tooltip : ItemInfoBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	if is_instance_valid(tooltip):
		tooltip.show_self()

func _on_mouse_exited() -> void:
	if is_instance_valid(tooltip):
		tooltip.visible = false
