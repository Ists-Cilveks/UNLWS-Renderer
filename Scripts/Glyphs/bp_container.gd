extends Node2D

func set_visibility(enabled):
	if enabled:
		show()
	else:
		hide()

func set_editing_mode(enabled):
	for child in get_children():
		child.set_editing_mode(enabled)
