extends UIButton

@export var scene_to_start : PackedScene

func _on_pressed() -> void:
	RunEvents.reset_run()
	var random_terrarium = TerrariumInfo.new()
	random_terrarium.randomize_materials()
	RunEvents.set_current_terrarium_info(random_terrarium)
	ScreenEvents.request_screen(ScreenEvents.Screen.TERRARIUM)
