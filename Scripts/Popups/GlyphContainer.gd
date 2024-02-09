extends Control

var glyph_instance

func _ready():
	#init(Glyph_List.glyphs["eat"])
	pass

func init(new_instance):
	glyph_instance = new_instance
	#assert(len(get_children()) == 0)
	add_child(glyph_instance)
	
	update_binding_points()

func _on_container_glyph_instance_set(new_instance):
	init(new_instance)


func update_binding_points():
	pass
	# TODO: how to do this?
