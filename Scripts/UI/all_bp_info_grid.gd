extends GridContainer

var bp_info_grid_scene = preload("./bp_info_grid.tscn")

var grids = []
var glyph_instance


func update(new_instance):
	create_attribute_list_from_instance(new_instance)


func create_attribute_list_from_instance(new_instance):
	destroy_attribute_list()
	
	# TODO: Find some way to check if the received child is a Glyph_Instance or some other not-yet-implemented class (like a rel line)
	#if not new_instance.is_class("Glyph_Instance"): return
	glyph_instance = new_instance
	create_attribute_list()

func create_attribute_list():
	var bp_list = glyph_instance.get_binding_points()
	for bp in bp_list:
		add_binding_point_info_grid(bp)

func destroy_attribute_list():
	for grid in grids:
		grid.free_children()
		grid.free()
	grids = []


func add_binding_point_info_grid(bp):
	var new_grid = bp_info_grid_scene.instantiate()
	new_grid.init(bp)
	
	grids.append(new_grid)
	add_child(new_grid)


#func _on_container_glyph_instance_set(new_instance):
	#glyph_instance = new_instance
	#create_attribute_list()
	#for grid in grids:
		#grid.update_text()
