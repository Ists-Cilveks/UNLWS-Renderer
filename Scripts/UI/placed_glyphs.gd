extends Node2D

#var glyph_instance_scene = preload("../Glyphs/glyph_instance.tscn")

#func delete_glyph_instance_by_name(glyph_name):
	#var child = get_child(glyph_name)
	#var restore_dict = child.get_restore_dict()
	#var lambda_self = self
	#var lambda_glyph_instance_scene = glyph_instance_scene
	#Undo_Redo.add_do_method(func(): lambda_self.remove_child(lambda_self.get_child(glyph_name)))
	#var restore_child = func restore_child():
		#var instance = lambda_glyph_instance_scene.instantiate()
		#instance.restore_from_dict(restore_dict)
		#lambda_self.add_child(instance)
	#Undo_Redo.add_undo_method(restore_child)
#
#func reparent_glyph_instance_by_name(glyph_name, new_parent):
	#var lambda_self = self
	#Undo_Redo.add_do_method(func(): lambda_self.get_node(glyph_name).reparent(new_parent))
	#Undo_Redo.add_undo_method(func(): new_parent.get_node(glyph_name).reparent(lambda_self))
