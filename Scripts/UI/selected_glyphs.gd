extends Node2D
## A container of all glyphs that are currently selected

var glyph_instance_scene = preload("../Glyphs/glyph_instance.tscn")

var glyphs = Glyph_List.glyphs
var is_holding_glyphs = false
var is_selecting_glyphs = false

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


func stop_holding():
	Undo_Redo.add_do_property(self, "is_holding_glyphs", false)
	Undo_Redo.add_undo_property(self, "is_holding_glyphs", is_holding_glyphs)
	Undo_Redo.add_do_method(func(): Event_Bus.stopped_holding_glyphs.emit())
	Undo_Redo.add_undo_method(func(): Event_Bus.started_holding_glyphs.emit())

func start_holding():
	Undo_Redo.add_do_property(self, "is_holding_glyphs", true)
	Undo_Redo.add_undo_property(self, "is_holding_glyphs", is_holding_glyphs)
	Undo_Redo.add_do_method(func(): Event_Bus.started_holding_glyphs.emit())
	Undo_Redo.add_undo_method(func(): Event_Bus.stopped_holding_glyphs.emit())


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
	
	stop_holding()

func delete():
	remove(true)

func place(new_parent):
	var children = get_children()
	for child in children:
		reparent_glyph_instance_by_name(child.name, new_parent, Vector2(child.position))
	
	stop_holding()


func overwrite(new_instance):
	delete()
	#add_child(new_instance)
	#Undo_Redo.add_do_method(func(): lambda_self.add_child(new_instance)) # Doesn't work because new_instance is lost
	var lambda_self = self
	var lambda_glyph_instance_scene = glyph_instance_scene
	
	var restore_dict = new_instance.get_restore_dict()
	var restore_child = func restore_child():
		var instance = lambda_glyph_instance_scene.instantiate()
		instance.restore_from_dict(restore_dict)
		lambda_self.add_child(instance)
	Undo_Redo.add_do_method(restore_child)
	
	start_holding()


func reparent_glyph_instance_by_name(glyph_name, new_parent, old_position = null):
	var lambda_self = self
	var node_path = NodePath(glyph_name)
	#Undo_Redo.add_do_method(func(): lambda_self.get_node(node_path).reparent(new_parent)) # Doesn't preserve position on redo
	var node = get_node(node_path)
	
	var new_position = new_parent.to_local(node.global_position)
	var do_method = func do_method():
		var do_node = lambda_self.get_node(node_path)
		do_node.position = new_position
		do_node.reparent(new_parent, false)
	Undo_Redo.add_do_method(do_method)
	
	var undo_method = func undo_method():
		var undo_node = new_parent.get_node(node_path)
		if old_position != null:
			undo_node.position = old_position
		undo_node.reparent(lambda_self, false)
	Undo_Redo.add_undo_method(undo_method)
