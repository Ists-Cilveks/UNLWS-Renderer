class_name UNLWS_Canvas_Element extends Node2D

var real_parent # The semi-permanent parent, usually not the SelectedGlyphs node (or maybe something else that's temporary).

func set_real_parent(new_parent):
	real_parent = new_parent
func get_real_parent():
	return real_parent
func get_parent_after_placing():
	return null
