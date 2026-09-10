extends TabContainer

func _on_previous_pressed():
	if current_tab > 0:
		current_tab -= 1
	else:
		current_tab = get_tab_count() - 1

func _on_next_pressed():
	if current_tab < get_tab_count() - 1:
		current_tab += 1
	else:
		current_tab = 0
