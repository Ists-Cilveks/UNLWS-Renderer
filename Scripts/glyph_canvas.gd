extends Node


func _ready():
	Event_Bus.glyph_search_succeeded.connect(hold_instance)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if $SelectedGlyphs.is_holding_glyphs:
				Undo_Redo.create_action("Place held glyphs")
				place_selected_glyphs()
				Undo_Redo.commit_action()
	if event is InputEventKey and event.pressed:
		if $SelectedGlyphs.is_holding_glyphs:
			if event.is_action_pressed("ui_text_delete") or event.is_action_pressed("ui_cancel"):
				Undo_Redo.create_action("Delete held glyphs")
				$SelectedGlyphs.delete()
				Undo_Redo.commit_action()
		if $SelectedGlyphs.is_selecting_glyphs:
			if event.is_action_pressed("ui_text_delete"):
				Undo_Redo.create_action("Delete selected glyphs")
				$SelectedGlyphs.delete()
				Undo_Redo.commit_action()
			elif event.is_action_pressed("ui_cancel"):
				Undo_Redo.create_action("Deselect glyphs")
				place_selected_glyphs()
				Undo_Redo.commit_action()


func place_selected_glyphs():
	$SelectedGlyphs.place($Glyphs)

func hold_instance(new_instance):
	$SelectedGlyphs.overwrite(new_instance)

