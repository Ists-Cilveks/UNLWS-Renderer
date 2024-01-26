class_name Glyph_Instance extends Node2D

var glyph_type

var style_dict = {}

var instance_g_node
var focus_bp_name
var focus_bp

@warning_ignore("shadowed_variable", "shadowed_variable_base_class")
func _init(glyph_type, position = Vector2(), rotation = 0, focus_bp_name = null):
	#var file = FileAccess.open(svg_path, FileAccess.READ)
	#var content = file.get_as_text()
	#var all_paths = get_paths_from_svg(content)
	self.glyph_type = glyph_type
	self.instance_g_node = glyph_type.xml_node.get_main_node_with_name("g").deep_copy()
	
	if not focus_bp_name in glyph_type.binding_points:
		var bp_names = glyph_type.binding_points.keys()
		if len(bp_names) > 0:
			focus_bp_name = bp_names[0]
	self.focus_bp_name = focus_bp_name
	if focus_bp_name in glyph_type.binding_points:
		self.focus_bp = glyph_type.binding_points[focus_bp_name]
	else:
		self.focus_bp = Binding_Point.new({}) # TODO: maybe change this so that Glyph_Type makes sure there is always at least a fallback BP, instead of that being taken care of in Glyph_Instance
	
	set_glyph_position(position)
	set_glyph_rotation(rotation)
	#print(glyph_type.name)
	
	#var all_paths = glyph_type.all_paths
	## From https://www.reddit.com/r/godot/comments/iban3j/comment/g1uwybu/ by https://www.reddit.com/user/bippinbits/
	#var selected_path = all_paths[0]
	#var l := Line2D.new()
	#l.default_color = Color(1,1,1,1)
	#l.width = 20
	#for point in selected_path.curve.get_baked_points():
		#l.add_point(point + selected_path.position)


func add_style(new_dict):
	for glyph_name in new_dict:
		style_dict[glyph_name] = new_dict[glyph_name]

func get_style_dict():
	return style_dict

func set_glyph_position(new_position):
	position = new_position
	update_node_transform()
func set_glyph_rotation(new_rotation):
	rotation = new_rotation
	update_node_transform()

func update_node_transform():
	instance_g_node.set_attribute("transform", get_transform_string())

func get_transform_string():
	var res = ""
	res += "translate("+str(position.x)+" "+str(position.y)+")\n"
	res += "rotate("+str(rotation)+" "+str(focus_bp.x)+" "+str(focus_bp.y)+")\n"
	return res
