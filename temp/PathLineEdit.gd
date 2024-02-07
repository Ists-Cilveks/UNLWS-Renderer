extends LineEdit

func _on_container_glyph_instance_set(new_instance):
	text = new_instance.glyph_type.sprite_path
