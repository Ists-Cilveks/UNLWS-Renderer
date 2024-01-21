extends Control







# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_glyph_search_entry_glyph_name_selected(glyph_name, glyphs):
#	$"Mouse/HeldGlyph".change_glyph(glyphs, glyph_name)
