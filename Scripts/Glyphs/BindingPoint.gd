class_name Binding_Point extends Node2D

var bp_name = ""
var dict = {}

var editing_enabled = true
var mouse_hovering = false
var being_dragged = false
var drag_start_pos
var drag_current_pos

func _ready():
	update_style()

func _init(init_dict = {}):
	init(init_dict)


func _unhandled_input(event):
	if editing_enabled and mouse_hovering:
		Drag_Handler.check_drag_start(event, self)


func _on_drag_area_mouse_entered():
	mouse_hovering = true
	update_style()

func _on_drag_area_mouse_exited():
	mouse_hovering = false
	update_style()


func update_drag_position(new_position):
	position = new_position

func end_drag():
	assert(being_dragged)
	being_dragged = false
	update_style()

func start_drag():
	assert(not being_dragged)
	being_dragged = true
	update_style()

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
	if not editing_enabled and being_dragged:
		Drag_Handler.end_drag()
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
	if being_dragged:
		$Sprite.modulate = Color(1, 0, 0)


func _on_tree_exiting():
	if being_dragged:
		Drag_Handler.end_drag()
