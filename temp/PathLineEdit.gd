extends LineEdit

func update(new_instance):
	if new_instance.get("glyph_type") != null:
		text = new_instance.glyph_type.sprite_path
	else:
		text = ""
