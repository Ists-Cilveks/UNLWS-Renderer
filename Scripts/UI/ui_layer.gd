extends CanvasLayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("ui_redo") or event.is_action_pressed("shift_ui_undo"):
			Undo_Redo.redo()
		elif event.is_action_pressed("ui_undo"):
			Undo_Redo.undo()
