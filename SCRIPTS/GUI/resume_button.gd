extends UIButton

func _on_pressed() -> void:
	HUDEvents.resume_pressed.emit()
