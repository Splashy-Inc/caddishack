extends UIButton

func _on_pressed() -> void:
	HUDEvents.how_to_requested.emit()
