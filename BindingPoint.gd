class_name Binding_Point extends Node

var bp_name = ""
var x = 0
var y = 0
var angle = 0
var dict = {}

func _init(init_dict):
	for key in init_dict:
		if key in ["x", "y", "angle"]:
			dict[key] = float(init_dict[key])
		else:
			dict[key] = init_dict[key]

func set_attribute(key, value):
	dict[key] = value
