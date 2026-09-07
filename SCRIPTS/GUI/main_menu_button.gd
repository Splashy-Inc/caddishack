extends UIButton

func _on_pressed() -> void:
	HUDEvents.main_menu_requested.emit()
