extends UIButton

func _on_pressed() -> void:
	HUDEvents.restart_pressed.emit()
