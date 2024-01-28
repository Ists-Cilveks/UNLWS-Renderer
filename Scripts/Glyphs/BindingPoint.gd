class_name Binding_Point extends Node2D

var bp_name = ""
var dict = {}

func _init(init_dict = {}):
	init(init_dict)

func init(init_dict):
	#print(init_dict)
	for key in init_dict:
		if key in ["x", "y", "angle"]:
			dict[key] = float(init_dict[key])
		else:
			assert(typeof(init_dict) == typeof({}))
			dict[key] = init_dict[key]
	
	if "x" in dict and "y" in dict:
		position = Vector2(dict["x"], dict["y"])
	if "angle" in dict:
		rotation_degrees = dict["angle"]

func set_attribute(key, value):
	dict[key] = value
