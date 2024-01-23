class_name XML_Node_From_Parser extends XML_Node

func is_attribute_worth_storing(name):
	if ":" in name:
		if name.begins_with(my_namespace+":"):
			return true
		else:
			return false
	else:
		return true

func create_attributes_dict(parser):
	var dict = {}
	for idx in range(parser.get_attribute_count()):
		var attribute_name = parser.get_attribute_name(idx)
		# NOTE: The attributes could be cleaned in the parent class, but I'm assuming that the XMLNodes that are getting passed around will already be clean
		if is_attribute_worth_storing(attribute_name):
			dict[attribute_name] = parser.get_attribute_value(idx)
	add_my_attributes(dict)
	return dict


@warning_ignore("shadowed_variable")
func _init(parser):
	var node_type = parser.get_node_type()
	var attributes_dict = {}
	var children = []
	if node_type == XMLParser.NODE_ELEMENT:
		node_name = parser.get_node_name()
		#if not parser.is_empty():
			#print("<"+node_name+">")
		#else:
			#print("<"+node_name+" />")
		attributes_dict = create_attributes_dict(parser)
	elif node_type == XMLParser.NODE_ELEMENT_END:
		#print(node_name, "==", parser.get_node_name())
		#assert(node_name == parser.get_node_name()) # TODO: there should be a check of this kind so that closing tags fit their opening tags
		#node_name = parser.get_node_name()
		#node_full_text = "</" + node_name + ">"
		#print(node_full_text)
		pass
	else:
		node_full_text = "" # TODO: how to actually extract source text from the parser?
	
	if not parser.is_empty() and node_type in [XMLParser.NODE_ELEMENT, XMLParser.NODE_NONE]: # The only nodes that need to be checked for children are the start node and elements that aren't empty (<element />)
		while parser.read() != ERR_FILE_EOF:
			if parser.get_node_type() == XMLParser.NODE_TEXT:# TODO: I'm not sure this is reliable. Does this get rid of all the nodes that are unneeded (there could be other types)? Are there text nodes (and info in them) that are necessary?
				continue
			var potential_child = XML_Node_From_Parser.new(parser)
			#print(potential_child.node_type)
			if potential_child.node_type == XMLParser.NODE_ELEMENT_END:
				break
			else:
				children.append(potential_child)
	
	super(node_name, attributes_dict, children, node_type)
