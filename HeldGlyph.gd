extends Node2D

##var local_glyph_list = $"/root/GlyphList".glyphs
##var local_glyph_list = GlyphList.glyphs
#var GlyphList = preload("./GlyphList.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(GlyphList.new().get_method_list())
#	print(glyphs)
	pass


func change_glyph(glyph_name, glyphs):
	if glyph_name in glyphs:
		var glyph = glyphs[glyph_name]
		var texture = glyph.get_texture()
		#print(texture)
		$Sprite.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var old_pos = position
#	var lagged_target_pos = get_viewport().get_mouse_position()
#	position = lagged_target_pos + (lagged_target_pos - old_pos)*0.5
#	position = get_viewport().get_mouse_position()
	pass


func _on_glyph_search_glyph_name_selected(glyph_name, glyphs):
	change_glyph(glyph_name, glyphs)
