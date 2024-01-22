class_name XML_Node extends Object

var children = []
var node_type
var node_name
var is_empty
var attributes_dict = {}
var node_full_text = "" # If the node can't be parsed, then its data will be stored directly so it can be inserted into a different XML file


func _init(init_name, init_attributes_dict={}, init_children=[], init_type=XMLParser.NODE_ELEMENT):
	node_type = init_type
	node_name = init_name
	attributes_dict = init_attributes_dict
	children = init_children	
	is_empty = (init_type == XMLParser.NODE_ELEMENT and len(init_children) == 0)


func get_string():
	var res = ""
	#print("num children:", len(children))
	#if len(children) == 1 :
		#print("num grandchildren:", len(children[0].children))
	for child in children:
		if child.node_type == XMLParser.NODE_ELEMENT:
			res += "<" + child.node_name
			if len(child.attributes_dict) != 0:
				for attribute_name in child.attributes_dict:
					res += "\n\t" + attribute_name + "=\"" + child.attributes_dict[attribute_name].xml_escape() + "\""
				if child.is_empty:
					res += " /"
			res += ">\n"
			res += child.get_string().indent("\t")
			if !child.is_empty:
				res += "</"+child.node_name+">\n"
		else:
			if len(child.node_full_text) > 0:
				res += child.node_full_text + "\n"
	return res


func get_main_node_with_name(name): # This node or the first descendant that has the given name
	if node_name == name:
		return self
	var num_children_with_main_nodes = 0
	var previous_main_node
	for child in children:
		var potential_main_node = child.get_main_node_with_name(name)
		if potential_main_node:
			previous_main_node = potential_main_node
			num_children_with_main_nodes += 1
	if num_children_with_main_nodes == 1:
		return previous_main_node
	elif num_children_with_main_nodes > 1:
		print("UNSUPPORTED SVG: There's a ", node_name, " node that has ", num_children_with_main_nodes, " children that each have a descendant that is a ", name," node.")


func deep_copy(): # TODO: I haven't really checked this and don't know how to 😬
	var new_attributes_dict = {}
	for name in attributes_dict:
		new_attributes_dict[name] = attributes_dict[name]
	var new_children = []
	for child in children:
		new_children.append(child.deep_copy())
	return XML_Node.new(node_name, new_attributes_dict, new_children, node_type)
