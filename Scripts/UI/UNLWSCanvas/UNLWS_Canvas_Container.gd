class_name UNLWS_Canvas_Container extends UNLWS_Canvas_Element


func _ready():
	real_parent = get_parent()


#region Non-undo-able functions (removing children etc)
func remove_child_without_undo_redo(child, delete_after_removing = true):
	assert(child in get_children())
	remove_child(child)
	if delete_after_removing:
		child.free()

func delete_child_without_undo_redo(child):
	remove_child_without_undo_redo(child, true)


func remove_all_without_undo_redo(delete_after_removing = true):
	for child in get_children():
		remove_child_without_undo_redo(child, delete_after_removing)

func delete_all_without_undo_redo():
	remove_all_without_undo_redo(true)


func remove_node_from_parent_by_name_without_undo_redo(node_name, delete_after_removing = true):
	get_parent().remove_descendant_by_name_without_undo_redo(node_name, delete_after_removing)

func remove_child_by_name_without_undo_redo(node_name, delete_after_removing = true):
	var node_path = NodePath(node_name)
	#Undo_Redo.add_do_method(func(): lambda_self.get_node(node_path).reparent(new_parent)) # Doesn't preserve position on redo
	var node = get_node(node_path)
	assert(node != null)
	
	remove_child_without_undo_redo(node, delete_after_removing)
#endregion


#region Descendant and ancestor functions
func get_descendant_by_name(node_name):
	return find_child(node_name, true, false)

func remove_descendant_by_name_without_undo_redo(node_name, delete_after_removing = true):
	var node = get_descendant_by_name(node_name)
	if delete_after_removing:
		node.free()
	else:
		node.get_parent().remove_child(node)


func get_UNLWS_canvas_root():
	return get_parent().get_UNLWS_canvas_root()
#endregion


#region Undo-able child removal functions
func remove_all(delete_after_removing = true):
	if get_child_count() > 0:
		var restore_all_children_function = get_restore_all_children_function()
		var lambda_self = self
		for child in get_children():
			var child_name = child.name
			Undo_Redo.add_do_method(func():
				# TODO: is this future-proof?
				# Will there eventually be other places that the glyph could have
				# been reparented to that aren't contained in the Canvas node?
				lambda_self.remove_node_from_parent_by_name_without_undo_redo(child_name, delete_after_removing))
		Undo_Redo.add_undo_method(restore_all_children_function)
		

func delete_all():
	remove_all(true)
#endregion


#region Glyph restoring functions
func get_restore_all_children_function():
	var restore_function_list = []
	for child in get_children():
		restore_function_list.append(get_restore_child_function(child))
	var restore_all_children_function = func restore_all_children_function():
		for restore_function in restore_function_list:
			restore_function.call()
	return restore_all_children_function

func get_restore_child_function(child, make_self_parent = false):
	var lambda_self = self
	var restore_func = child.get_restore_function()
	var old_position = Vector2(position)
	
	var restore_child_function = func restore_child_function():
		#var instance = lambda_glyph_instance_scene.instantiate()
		#instance.restore_from_dict(restore_dict)
		var instance = restore_func.call()
		if make_self_parent:
			lambda_self.add_child(instance)
			#instance.set_real_parent(lambda_self)
		else:
			instance.set_position(old_position)
			assert(instance.real_parent != null)
			instance.real_parent.add_child(instance)
	
	return restore_child_function


func restore_child(child, make_self_parent = false):
	Undo_Redo.add_do_method(get_restore_child_function(child, make_self_parent))
	var lambda_self = self
	Undo_Redo.add_undo_method(func(): lambda_self.remove_child_by_name_without_undo_redo(child.name))
#endregion

