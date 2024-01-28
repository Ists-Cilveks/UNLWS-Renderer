extends Node2D

var glyph_instance_scene = preload("../Glyphs/glyph_instance.tscn")

var glyphs = Glyph_List.glyphs

func set_by_name(glyph_name):
	remove()
	if glyph_name in glyphs:
		var glyph_type = glyphs[glyph_name]
		var node = glyph_instance_scene.instantiate()
		node.init(glyph_type)
		add_child(node)

func remove(delete = true):
	var children = get_children()
	for child in children:
		remove_child(child)
		if delete:
			child.free()

func place(new_parent):
	var children = get_children()
	for child in children:
		child.reparent(new_parent)
