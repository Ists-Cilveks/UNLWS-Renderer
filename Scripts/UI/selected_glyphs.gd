extends Node2D
## A container of all glyphs that are currently selected

var glyph_instance_scene = preload("../Glyphs/glyph_instance.tscn")

var is_holding_glyphs = false
var is_selecting_glyphs = false

# Track the mouse position
func _unhandled_input(event):
	if event is InputEventMouseMotion \
		and not is_selecting_glyphs:
		position = get_global_mouse_position()


func set_by_name(glyph_name):
	remove_all()
	if glyph_name in Glyph_List.glyphs:
		var glyph_type = Glyph_List.glyphs[glyph_name]
		var node = glyph_instance_scene.instantiate()
		node.init(glyph_type)
		add_child(node)


func signal_stop_holding_child(_child):
	var lambda_self = self
	Undo_Redo.add_do_method(func stop_holding_child():
		if lambda_self.get_child_count() == 0:
			lambda_self.signal_stop_holding()
		)
	Undo_Redo.add_undo_method(lambda_self.signal_start_holding)

func signal_start_holding_child(_child):
	var lambda_self = self
	Undo_Redo.add_do_method(lambda_self.signal_start_holding)
	Undo_Redo.add_undo_method(func undo_start_holding_child():
		if lambda_self.get_child_count() == 0:
			lambda_self.signal_stop_holding()
		)

func signal_stop_holding():
	is_holding_glyphs = false
	Event_Bus.stopped_holding_glyphs.emit()

func signal_start_holding():
	is_holding_glyphs = true
	Event_Bus.started_holding_glyphs.emit(self.get_children())

func remove_child_without_undo_redo(child, delete_after_removing = true):
	assert(child in get_children())
	remove_child(child)
	if delete_after_removing:
		child.free()

# Remove all children (without having pointers to them)
func remove_all_without_undo_redo(delete_after_removing = true):
	for child in get_children():
		remove_child_without_undo_redo(child, delete_after_removing)

func delete_child_without_undo_redo(child):
	remove_child_without_undo_redo(child, true)

func delete_all_without_undo_redo():
	remove_all_without_undo_redo(true)


func remove_all(delete_after_removing = true):
	# TODO: undoing deletion of selected glyphs doesn't work
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
		Undo_Redo.add_undo_method(deselect_all)
		Undo_Redo.add_undo_method(restore_all_children_function)
		if is_holding_glyphs:
			Undo_Redo.add_do_property(self, "is_holding_glyphs", false)
			Undo_Redo.add_undo_property(self, "is_holding_glyphs", true)
			Undo_Redo.add_do_method(func(): Event_Bus.stopped_holding_glyphs.emit())
			Undo_Redo.add_undo_method(func(): Event_Bus.started_holding_glyphs.emit(lambda_self.get_children()))
		if is_selecting_glyphs:
			Undo_Redo.add_do_property(self, "is_selecting_glyphs", false)
			Undo_Redo.add_undo_property(self, "is_selecting_glyphs", true)
			# Also restore this node's position so the selection appears in the right place on undo.
			var lambda_position = Vector2(position)
			Undo_Redo.add_undo_property(self, "position", lambda_position)

func delete_all():
	remove_all(true)


func place_child(child, new_parent):
	reparent_glyph_instance_by_name(child.name, new_parent, Vector2(child.position))
	signal_stop_holding_child(child)

func place_all(new_parent):
	Undo_Redo.add_do_method(deselect_all)
	Undo_Redo.add_undo_method(deselect_all)
	for child in get_children():
		place_child(child, new_parent)


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
	var lambda_glyph_instance_scene = glyph_instance_scene
	
	var restore_dict = child.get_restore_dict()
	restore_dict["position"] += position
	
	var restore_child_function = func restore_child_function():
		var instance = lambda_glyph_instance_scene.instantiate()
		instance.restore_from_dict(restore_dict)
		if make_self_parent:
			lambda_self.add_child(instance)
		else:
			assert(instance.real_parent != null)
			instance.real_parent.add_child(instance)
	
	return restore_child_function

func restore_child(child, make_self_parent = false):
	Undo_Redo.add_do_method(get_restore_child_function(child, make_self_parent))
	var lambda_self = self
	Undo_Redo.add_undo_method(func(): lambda_self.remove_child_by_name_without_undo_redo(child.name))

func remove_node_from_parent_by_name_without_undo_redo(node_name, delete_after_removing = true):
	get_parent().remove_descendant_by_name_without_undo_redo(node_name, delete_after_removing)

func remove_child_by_name_without_undo_redo(node_name, delete_after_removing = true):
	var node_path = NodePath(node_name)
	#Undo_Redo.add_do_method(func(): lambda_self.get_node(node_path).reparent(new_parent)) # Doesn't preserve position on redo
	var node = get_node(node_path)
	assert(node != null)
	
	remove_child_without_undo_redo(node, delete_after_removing)


func overwrite_hold(new_instance: Glyph_Instance):
	Undo_Redo.add_do_method(deselect_all)
	Undo_Redo.add_undo_method(deselect_all)
	if is_holding_glyphs:
		delete_all()
	restore_child(new_instance, true)
	signal_start_holding_child(new_instance)


func reparent_glyph_instance_by_name(glyph_name, new_parent, old_position = null, old_real_parent = null):
	var lambda_self = self
	var node_path = NodePath(glyph_name)
	#Undo_Redo.add_do_method(func(): lambda_self.get_node(node_path).reparent(new_parent)) # Doesn't preserve position on redo
	var node = get_node(node_path)
	
	var new_position = new_parent.to_local(node.global_position)
	var do_method = func do_method():
		var do_node = lambda_self.get_node(node_path)
		do_node.position = new_position
		if new_parent == lambda_self:
			do_node.reparent(new_parent, false)
		else:
			do_node.permanent_reparent(new_parent)
	Undo_Redo.add_do_method(do_method)
	
	var undo_method = func undo_method():
		var undo_node = new_parent.get_node(node_path)
		if old_position != null:
			undo_node.position = old_position
		if old_real_parent != null:
			undo_node.set_real_parent(old_real_parent)
		undo_node.reparent(lambda_self, false)
	Undo_Redo.add_undo_method(undo_method)


#region Glyph selection methods
func deselect_instance(child):
	var real_parent = child.get_real_parent()
	if real_parent != null:
		child.reparent(real_parent)
		child.set_is_selected(false)
	else:
		delete_child_without_undo_redo(child)
	if get_child_count() == 0:
		Event_Bus.stopped_selecting_glyphs.emit(get_children())
		is_selecting_glyphs = false
	else:
		Event_Bus.started_selecting_glyphs.emit(get_children())
		# TODO: maybe use a separate signal instead of reusing this even when going from 2 to 1 children

func select_instance(child):
	child.reparent(self)
	child.set_is_selected(true)
	Event_Bus.started_selecting_glyphs.emit(get_children())
	is_selecting_glyphs = true

func deselect_all():
	if not is_selecting_glyphs: return
	is_selecting_glyphs = false
	for child in get_children():
		deselect_instance(child)

func attempt_to_overwrite_selection(new_instance):
	if is_holding_glyphs: return false
	if is_selecting_glyphs:
		deselect_all()
	select_instance(new_instance)
	is_selecting_glyphs = true
	Event_Bus.started_selecting_glyphs.emit(get_children())
	return true

func attempt_to_select_extra_instance(new_instance):
	if is_holding_glyphs: return false
	if new_instance.get_is_selected():
		deselect_instance(new_instance)
	else:
		select_instance(new_instance)
	return true
#endregion
