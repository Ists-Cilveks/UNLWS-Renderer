extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	var old_pos = position
#	var lagged_target_pos = get_viewport().get_mouse_position()
#	position = lagged_target_pos + (lagged_target_pos - old_pos)*0.5
	position = get_viewport().get_mouse_position()

func place_held_glyph(new_parent):
	$HeldGlyph.place(new_parent)
	$Cursor.show()

func _on_glyph_search_glyph_name_selected(glyph_name):
	$HeldGlyph.set_by_name(glyph_name)
	$Cursor.hide()
