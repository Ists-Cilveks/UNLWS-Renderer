extends Node
## A singleton for undo and redo actions.
## In order to update button styling, call the custom functions
## (commit_action_with_signals instead of commit_action etc.)
## which send custom signals.

var undo_redo = UndoRedo.new()

signal undo_pressed
signal out_of_undos
signal gained_undo
signal redo_pressed
signal out_of_redos
signal gained_redo

func commit_action():
	undo_redo.add_do_method(send_do_signals)
	undo_redo.add_undo_method(send_undo_signals)
	undo_redo.commit_action()


func undo():
	assert(undo_redo.has_undo())
	if undo_redo.has_undo():
		undo_redo.undo()

func redo():
	assert(undo_redo.has_redo())
	if undo_redo.has_redo():
		undo_redo.redo()


func send_do_signals():
	gained_undo.emit()
	if not undo_redo.has_redo():
		out_of_redos.emit()

func send_undo_signals():
	gained_redo.emit()
	if not undo_redo.has_undo():
		out_of_undos.emit()
