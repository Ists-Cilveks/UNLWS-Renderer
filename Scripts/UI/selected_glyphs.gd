extends Node2D
## A container of all glyphs that are currently selected

var glyph_instance_scene = preload("../Glyphs/glyph_instance.tscn")

var glyphs = Glyph_List.glyphs

func _process(_delta):
	position = get_global_mouse_position()

func set_by_name(glyph_name):
	remove()
	if glyph_name in glyphs:
		var glyph_type = glyphs[glyph_name]
		var node = glyph_instance_scene.instantiate()
		node.init(glyph_type)
		add_child(node)

func remove(delete_after_removing = true):
	var children = get_children()
	for child in children:
		remove_child(child)
		if delete_after_removing:
			child.free()

func delete():
	remove(true)

func place(new_parent):
	var children = get_children()
	for child in children:
		child.reparent(new_parent)

func overwrite(new_instance):
	delete()
	add_child(new_instance)


