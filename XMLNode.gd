extends Object
var XMLNode = preload("./XMLNode.gd")

var children = []
var node_type
var node_name
var is_empty
var attributes_dict = {}
var node_can_be_parsed = false # Becomes true if this is a node with data (like attributes) that I want to extract and save
var node_full_text # If the node can't be parsed, then its data will be stored directly so it can be inserted into a different XML file

func is_attribute_worth_storing(name):
	if name.begins_with("inkscape:"):
		return false
	else:
		return true

func _init(parser):
	node_type = parser.get_node_type()
	is_empty = parser.is_empty()
	if node_type == XMLParser.NODE_ELEMENT:
		node_name = parser.get_node_name()
		#if not parser.is_empty():
			#print("<"+node_name+">")
		#else:
			#print("<"+node_name+" />")
		node_can_be_parsed = true
		for idx in range(parser.get_attribute_count()):
			var attribute_name = parser.get_attribute_name(idx)
			if is_attribute_worth_storing(attribute_name):
				attributes_dict[attribute_name] = parser.get_attribute_value(idx)
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
			var potential_child = XMLNode.new(parser)
			#print(potential_child.node_type)
			if potential_child.node_type == XMLParser.NODE_ELEMENT_END:
				break
			else:
				children.append(potential_child)
	#print("Name: ", parser.get_node_name(), " ", parser.get_node_type())
	#print("Num children: ", len(children))
	#if true:
		#pass
	#print(get_string())
	
	#var res = ""
	##print("num children:", len(children))
	##if len(children) == 1 :
		##print("num grandchildren:", len(children[0].children))
	#for child in children:
		##print(child.node_name," node_can_be_parsed: ",child.node_can_be_parsed)
		#if child.node_can_be_parsed:
			#if child.node_type == XMLParser.NODE_ELEMENT:
				#res += "<" + child.node_name + " "
				#var is_first_attribute = true
				#for attribute_name in child.attributes_dict:
					#if is_first_attribute:
						#is_first_attribute = false
					#else:
						#res += "\n\t"
					#res += attribute_name + ": \"" + child.attributes_dict[attribute_name] + "\""
				#res += ">"
				#res += child.get_string().indent("\t")
				#
			#elif child.node_type == XMLParser.NODE_ELEMENT_END:
				#res += "</"+child.node_name+">"
			##print(child.node_name)
			##print(res)
			#print(res)
		#else:
			#print(child.node_full_text)
		

func get_string():
	var res = ""
	#print("num children:", len(children))
	#if len(children) == 1 :
		#print("num grandchildren:", len(children[0].children))
	for child in children:
		#print(child.node_name," node_can_be_parsed: ",child.node_can_be_parsed)
		if child.node_can_be_parsed:
			if child.node_type == XMLParser.NODE_ELEMENT:
				res += "<" + child.node_name + " "
				var is_first_attribute = true
				for attribute_name in child.attributes_dict:
					if is_first_attribute:
						is_first_attribute = false
					else:
						res += "\n\t"
					res += attribute_name + "=\"" + child.attributes_dict[attribute_name] + "\""
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
