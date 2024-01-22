extends Node2D


func change_glyph(glyph_name, glyphs):
	if glyph_name in glyphs:
		var glyph = glyphs[glyph_name]
		var texture = glyph.get_texture()
		$Sprite.texture = texture

func _on_glyph_search_glyph_name_selected(glyph_name, glyphs):
	change_glyph(glyph_name, glyphs)
