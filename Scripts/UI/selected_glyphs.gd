extends Node2D
## A container of all glyphs that are currently selected

var glyph_instance_scene = preload("../Glyphs/glyph_instance.tscn")

var glyphs = Glyph_List.glyphs

func _process(_delta):
#	var old_pos = position
#	var lagged_target_pos = get_viewport().get_mouse_position()
#	position = lagged_target_pos + (lagged_target_pos - old_pos)*0.5
	var viewport = get_viewport()
	#var ref = viewport.get_camera_2d()
	var ref = get_parent()
	#position = ref.to_local(viewport.get_mouse_position())
	#position = viewport.get_mouse_position()
	position = get_global_mouse_position()

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

func delete():
	remove(true)

func place(new_parent):
	var children = get_children()
	for child in children:
		child.reparent(new_parent)


func place_held_glyph(new_parent):
	$HeldGlyph.place(new_parent)
	$Cursor.show()

func _on_glyph_search_glyph_name_selected(glyph_name):
	$HeldGlyph.set_by_name(glyph_name)
	$Cursor.hide()


