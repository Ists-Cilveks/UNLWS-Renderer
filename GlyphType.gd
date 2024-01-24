class_name Glyph_Type extends Object

var name
var sprite_path
var texture_is_loaded = false
var texture
var xml_node
var all_paths = []

func _init(init_name, init_sprite_path):
	name = init_name
	sprite_path = init_sprite_path
	get_xml_node_from_svg_path(sprite_path)

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

#func get_xml_node_from_svg_path(svg_string):
func get_xml_node_from_svg_path(svg_path):
	# Modified from https://docs.godotengine.org/en/stable/classes/class_xmlparser.html [accessed 2024-01-21]
	var parser = XMLParser.new()
	parser.open(svg_path)
	
	xml_node = XML_Node_From_Parser.new(parser)
	xml_node.get_main_node_with_name("g").add_attribute("id", name)
	
	#print(xml_node.get_string())
	#print(xml_node.deep_copy().get_string() == xml_node.get_string())
	#print(xml_node.get_main_node_with_name("g"))
	
	#var test_file = FileAccess.open(
		#"res://Images/Output/"+svg_path.rsplit("/", true, 1)[1],
		#FileAccess.WRITE)
	#test_file.store_string(xml_node.get_string())
	
	return xml_node
