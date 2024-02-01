extends Node2D
## A container of all glyphs that are currently selected

var glyph_instance_scene = preload("../Glyphs/glyph_instance.tscn")

var glyphs = Glyph_List.glyphs

# Track the mouse position
func _input(event):
	if event is InputEventMouseMotion:
		position = get_global_mouse_position()

func set_by_name(glyph_name):
	remove()
	if glyph_name in glyphs:
		var glyph_type = glyphs[glyph_name]
		var node = glyph_instance_scene.instantiate()
		node.init(glyph_type)
		add_child(node)

# Remove all children (without having pointers to them)
func remove_without_undo_redo(delete_after_removing = true):
	var children = get_children()
	for child in children:
		remove_child(child)
		if delete_after_removing:
			child.free()

func delete_without_undo_redo():
	remove_without_undo_redo(true)

func remove(delete_after_removing = true):
	var lambda_self = self
	var lambda_glyph_instance_scene = glyph_instance_scene
	
	#var remove_all_children = func remove_all_children():
		#var do_children = lambda_self.get_children()
		#for child in do_children:
			#lambda_self.remove_child(child)
			#if delete_after_removing:
				#child.free()
	#Undo_Redo.add_do_method(remove_all_children)
	#Undo_Redo.add_undo_method(remove_all_children)
	Undo_Redo.add_do_method(delete_without_undo_redo)
	Undo_Redo.add_undo_method(delete_without_undo_redo)
	
	# "undo" part (define lambdas so that the previously removed children can be restored)
	var undo_children = get_children()
	for child in undo_children:
		if delete_after_removing:
			var restore_dict = child.get_restore_dict()
			var restore_child = func restore_child():
				var instance = lambda_glyph_instance_scene.instantiate()
				instance.restore_from_dict(restore_dict)
				lambda_self.add_child(instance)
			Undo_Redo.add_undo_method(restore_child)
		else:
			Undo_Redo.add_undo_method(func(): lambda_self.add_child(child))

func delete():
	remove(true)

func place(new_parent):
	var lambda_self = self
	var lambda_glyph_instance_scene = glyph_instance_scene
	
	# "do" part (place all held glyphs)
	var reparent_all_children = func reparent_all_children():
		var do_children = lambda_self.get_children()
		for child in do_children:
			child.reparent(new_parent)
	Undo_Redo.add_do_method(reparent_all_children)
	
	# "undo" part (hold the glyphs that were previously placed)
	# TODO: this is bad. Undoing glyph placement should be done with reparenting,
	# not saving the data of the glyphs temporarily in a lambda and then calling it
	# to delete the current selection and reconstruct the glyphs.
	# FIXME: i can't delete everything, because it's in the actual canvas,
	# not just the current selection
	Undo_Redo.add_undo_method(delete_without_undo_redo)
	var undo_children = get_children()
	for child in undo_children:
		var restore_dict = child.get_restore_dict()
		var restore_child = func restore_child():
			var instance = lambda_glyph_instance_scene.instantiate()
			instance.restore_from_dict(restore_dict)
			lambda_self.add_child(instance)
		Undo_Redo.add_undo_method(restore_child)
		#Undo_Redo.add_undo_method(func(): child.reparent(lambda_self, false))


func overwrite(new_instance):
	#delete()
	#add_child(new_instance)
	delete()
	#Undo_Redo.add_do_method(func(): lambda_self.add_child(new_instance)) # Doesn't work because new_instance is lost
	var lambda_self = self
	var lambda_glyph_instance_scene = glyph_instance_scene
	
	var restore_dict = new_instance.get_restore_dict()
	var restore_child = func restore_child():
		var instance = lambda_glyph_instance_scene.instantiate()
		instance.restore_from_dict(restore_dict)
		lambda_self.add_child(instance)
	Undo_Redo.add_do_method(restore_child)


