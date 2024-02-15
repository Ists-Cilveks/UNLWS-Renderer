class_name Binding_Point extends Node2D

var bp_name = ""
var dict = {}

var editing_enabled = false
var mouse_hovering = false
var being_dragged = false

func _ready():
	update_style()

func _init(init_dict = {}):
	init(init_dict)


func _unhandled_input(event):
	if editing_enabled and mouse_hovering:
		var lambda_viewport = get_viewport()
		var on_drag_start_success = func on_drag_start_success():
			lambda_viewport.set_input_as_handled()
		Drag_Handler.start_drag_if_possible(event, self, on_drag_start_success)


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
	Undo_Redo.create_action("Change binding point position by dragging")
	var lambda_dict = dict
	var new_x = position.x
	var new_y = position.y
	Undo_Redo.add_do_method(func():
		lambda_dict["owner"].set_bp_position(new_x, new_y)
	)
	var start_x = Drag_Handler.local_node_start_pos.x
	var start_y = Drag_Handler.local_node_start_pos.y
	Undo_Redo.add_undo_method(func():
		lambda_dict["owner"].set_bp_position(start_x, start_y)
	)
	Undo_Redo.commit_action()

func start_drag():
	assert(not being_dragged)
	being_dragged = true
	update_style()


func init(init_dict, create_copy = false):
	assert(typeof(init_dict) == typeof({}))
	
	if not create_copy:
		dict = init_dict
	
	for key in init_dict:
		if key in ["x", "y", "angle"]:
			dict[key] = float(init_dict[key])
		elif create_copy: # If dict = init_dict, this would be a no-op
			dict[key] = init_dict[key]
	
	dict["owner"] = self
	
	if "x" in dict and "y" in dict:
		position = Vector2(dict["x"], dict["y"])
	if "angle" in dict:
		rotation_degrees = dict["angle"]

func set_attribute(key, value):
	dict[key] = value

func set_bp_position(x, y):
	position = Vector2(x, y)
	set_attribute("x", x)
	set_attribute("y", y)
	if "xml_node" in dict:
		pass # TODO: keep the XML node up to date (assuming that's necessary)


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


#region save/restore with a dict
func get_restore_dict():
	return dict

func restore_from_dict(restore_dict):
	init(restore_dict)
#endregion
