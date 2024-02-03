extends Node

var holding_glyph = false

func _ready():
	Event_Bus.glyph_search_succeeded.connect(hold_instance)

func _unhandled_input(event):
	#print(holding_glyph)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if holding_glyph:
				Undo_Redo.create_action("Place held glyphs")
				place_held_glyphs()
				Undo_Redo.commit_action()

func place_held_glyphs():
	$SelectedGlyphs.place($Glyphs)
	Undo_Redo.add_do_property(self, "holding_glyph", false)
	Undo_Redo.add_undo_property(self, "holding_glyph", holding_glyph)
	Undo_Redo.add_do_method(func(): Event_Bus.stopped_holding_glyphs.emit())
	Undo_Redo.add_undo_method(func(): Event_Bus.started_holding_glyphs.emit())

#func set_by_name(glyph_name):
	#$SelectedGlyphs.set_by_name(glyph_name)
	#holding_glyph = true
	#Event_Bus.started_holding_glyphs.emit()

func hold_instance(new_instance):
	#var selected_glyphs = $SelectedGlyphs
	#Undo_Redo.add_do_method(func():
		##$SelectedGlyphs.overwrite(new_instance)
		##print(new_instance)
		##print($SelectedGlyphs)
		##print(selected_glyphs)
		#selected_glyphs.overwrite(new_instance)
	#)
	$SelectedGlyphs.overwrite(new_instance)
	Undo_Redo.add_do_property(self, "holding_glyph", true)
	Undo_Redo.add_undo_property(self, "holding_glyph", holding_glyph)
	Undo_Redo.add_do_method(func(): Event_Bus.started_holding_glyphs.emit())
	Undo_Redo.add_undo_method(func(): Event_Bus.stopped_holding_glyphs.emit())

