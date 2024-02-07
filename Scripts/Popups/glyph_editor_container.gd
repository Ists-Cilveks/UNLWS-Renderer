extends Control

signal glyph_instance_set(new_instance)

var glyph_instance_scene = preload("../Glyphs/glyph_instance.tscn")
var glyph_instance

func _ready():
	# TODO: temporary, set_glyph_instance should be called from outside the scene
	var new_glyph_type = Glyph_List.glyphs["cat"]
	var new_instance = glyph_instance_scene.instantiate()
	new_instance.init(new_glyph_type)
	set_glyph_instance(new_instance)


func set_glyph_instance(new_instance):
	glyph_instance = new_instance
	glyph_instance_set.emit(new_instance)
