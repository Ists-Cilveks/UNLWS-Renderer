extends LineEdit

func _on_glyph_container_glyph_type_set(glyph_type):
	text = glyph_type.sprite_path
