class_name Glyph_Type extends Object

var sprite_path
var texture_is_loaded = false
var texture
var xml_node
var all_paths = []

## Modified from https://github.com/godotengine/godot-docs/issues/2148 by Justo Delgado (mrcdk)
#func get_external_texture(path):
	#if !texture_is_loaded:
		#var img = Image.new()
		#img.load(path)
		#texture = ImageTexture.new()
		#texture = texture.create_from_image(img)
		#texture_is_loaded = true
	#return texture

#func get_texture_from_external_svg(path):
func get_texture():
	if !texture_is_loaded:
		var buffer = FileAccess.get_file_as_bytes(sprite_path)
		var img = Image.new()
		img.load_svg_from_buffer(buffer, 25.0)
		texture = ImageTexture.new()
		texture = texture.create_from_image(img)
		texture_is_loaded = true
	return texture

#func get_paths_from_svg(svg_string):
func get_paths_from_svg(svg_path):
	# Modified from https://docs.godotengine.org/en/stable/classes/class_xmlparser.html [accessed 2024-01-21]
	var parser = XMLParser.new()
	parser.open(svg_path)
	print("READING ", svg_path)
	
	xml_node = XML_Node_From_Parser.new(parser)
	
	#print(xml_node.get_string())
	#print(xml_node.deep_copy().get_string() == xml_node.get_string())
	#print(xml_node.get_main_node_with_name("g"))
	
	var test_file = FileAccess.open(
		"res://Images/Output/"+svg_path.rsplit("/", true, 1)[1],
		FileAccess.WRITE)
	test_file.store_string(xml_node.get_string())
	
	#var temp_stack = [[xml_node, 0]]
	#var temp_depth = 0
	#var temp_string = ""
	#var tab_string = ""
	#while len(temp_stack) > 0:
		#var top_element = temp_stack[-1]
		#var cur_node = top_element[0]
		#var children_list = cur_node.children
		#var index = top_element[1]
		#if index == 0:
			#temp_string += tab_string + "<"+str(cur_node.node_name)+"> "+str(cur_node.node_type)+"\n"
		##print(len(children_list))
		#if index < len(children_list):
			#temp_stack.append([children_list[index], 0])
			#top_element[1] += 1
			#temp_depth += 1
			#tab_string += "\t"
		#else:
			#var temp_node = temp_stack.pop_back()[0]
			##temp_string += tab_string + "</"+str(temp_node.node_name)+">\n"
			#temp_depth -= 1
			#tab_string = tab_string.left(len(tab_string)-1)
	#print(temp_string)
	
	print()
	#while parser.read() != ERR_FILE_EOF:
		#if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			#var node_name = parser.get_node_name()
			#var attributes_dict = {}
			#for idx in range(parser.get_attribute_count()):
				#attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
			#print("The ", node_name, " element has the following attributes: ", attributes_dict)
	return xml_node

func _init(init_sprite_path):
	sprite_path = init_sprite_path
	get_paths_from_svg(sprite_path)

