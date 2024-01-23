extends Node2D

var glyphs

func change_glyph(glyph_name):
	if glyph_name in glyphs:
		var glyph = glyphs[glyph_name]
		var texture = glyph.get_texture()
		$Sprite.texture = texture

func _on_glyph_search_glyph_name_selected(glyph_name, glyphs):
	change_glyph(glyph_name)

func _on_unlws_ui_glyph_list_set(glyph_list):
	glyphs = glyph_list
