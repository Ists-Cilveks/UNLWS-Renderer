extends Button

func _ready():
	Undo_Redo.out_of_undos.connect(disable)
	Undo_Redo.gained_undo.connect(enable)
	Event_Bus.overlay_closed.connect(focus)
	focus()

func _on_pressed():
	Undo_Redo.undo()


func focus():
	get_viewport().gui_get_focus_owner().release_focus.call_deferred()
	grab_focus.call_deferred()


func disable():
	disabled = true

func enable():
	disabled = false
