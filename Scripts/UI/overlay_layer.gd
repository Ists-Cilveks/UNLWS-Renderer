extends CanvasLayer


func _ready():
	Event_Bus.overlay_closed.connect(func(): set_input_handling(false))
	Event_Bus.overlay_opened.connect(func(): set_input_handling(true))
	set_input_handling(false)

func set_input_handling(enabled):
	# TODO: this is a bad solution
	set_process_unhandled_input(enabled)
	for child in get_children():
		child.set_process_unhandled_input(enabled)
