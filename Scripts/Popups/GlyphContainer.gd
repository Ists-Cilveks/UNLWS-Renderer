extends Control

signal glyph_type_set(glyph_type)

var glyph_instance_scene = preload("../Glyphs/glyph_instance.tscn")

func _ready():
	init(Glyph_List.glyphs["eat"])

func init(glyph_type):
	var glyph_instance = glyph_instance_scene.instantiate()
	glyph_instance.init(glyph_type)
	add_child(glyph_instance)
	glyph_type_set.emit(glyph_type)
