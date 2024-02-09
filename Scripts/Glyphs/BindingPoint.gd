class_name Binding_Point extends Node2D

var bp_name = ""
var dict = {}

var editing_enabled = false
var mouse_hovering = false

func _ready():
	$Sprite.modulate = Global_Colors.binding_point["default"]

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


func set_editing_mode(enabled):
	if editing_enabled == enabled: return
	editing_enabled = enabled
	update_style()


func update_style():
	var color_name = "default"
	if editing_enabled:
		color_name = "editable"
		if mouse_hovering:
			color_name = "hover_editable"
	elif mouse_hovering:
		color_name = "hover"
	$Sprite.modulate = Global_Colors.binding_point[color_name]


func _on_drag_area_mouse_entered():
	print("asdfasdf")
	mouse_hovering = true
	update_style()


func _on_drag_area_mouse_exited():
	mouse_hovering = false
	update_style()
