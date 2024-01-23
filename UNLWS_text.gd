class_name UNLWS_Text extends Object

var required_defs = []
var xml_node
var g_node
var svg_node
var defs_node


func _init():
	defs_node = XML_Node.new("defs")
	g_node = XML_Node.new("g")
	var svg_attributes = {
		"xmlns": "http://www.w3.org/2000/svg",
		"xmlns:svg": "http://www.w3.org/2000/svg",
	}
	svg_node = XML_Node.new("svg", svg_attributes, [defs_node, g_node])
	xml_node = XML_Node.new(null, {}, [svg_node])

func add_glyph(instance):
	if not instance.glyph_type in required_defs:
		required_defs.append(instance.glyph_type)
	g_node.add_child(instance.glyph_type.xml_node.get_main_node_with_name("g"))
