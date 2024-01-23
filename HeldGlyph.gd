extends Node2D

var glyphs = Glyph_List.glyphs

func change_glyph(glyph_name):
	if glyph_name in glyphs:
		var glyph = glyphs[glyph_name]
		var texture = glyph.get_texture()
		$Sprite.texture = texture
