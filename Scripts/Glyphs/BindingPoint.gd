class_name Binding_Point extends Node2D
## An UNLWS binding point (BP), to be instantiated with the binding point scene as a Glyph_Instance's child.
## Has a position and rotation (to tell which direction rel lines should connect to)

var bp_name = ""
var self_scene = preload("./binding_point.tscn")

## dict holds all permanent information about this BP.
## If a BP is being instanced from a glyph type, the dict should be copied element by element. (see create_copy in init)
## Otherwise, if the dict of a specific (potentially user-modified) BP was saved and restored, the dict should be passed by reference.
## This allows the dict to stay up-to-date on what its owner is, so Undo_Redo functions can rely on it while setting/restoring the BP's properties.
var dict = {}

var editing_enabled = false
var mouse_drag_hovering = false
var mouse_rotation_hovering = false
var being_dragged = false
var being_held = false

var real_parent

func _ready():
	update_style()

func _init(init_dict = {}, create_copy = false, new_real_parent = null):
	init(init_dict, create_copy, new_real_parent)


#region Dragging
func _input(event):
	if being_dragged:
		Drag_Handler.process_input_event(event)


func _unhandled_input(event):
	if editing_enabled:
		if mouse_rotation_hovering:
			Drag_Handler.start_drag_if_possible(event, self, true, true)
		elif mouse_drag_hovering:
			Drag_Handler.start_drag_if_possible(event, self, true)
		


func _on_drag_area_mouse_entered():
	mouse_drag_hovering = true
	update_style()

func _on_drag_area_mouse_exited():
	mouse_drag_hovering = false
	update_style()


func _on_rotation_drag_area_mouse_entered():
	mouse_rotation_hovering = true
	update_style()

func _on_rotation_drag_area_mouse_exited():
	mouse_rotation_hovering = false
	update_style()


func update_drag_position(new_position):
	set_bp_position(new_position.x, new_position.y)
func update_drag_rotation(new_rotation):
	set_bp_rotation(new_rotation)

func end_drag():
	assert(being_dragged)
	being_dragged = false
	update_style()
	
	var lambda_dict = dict
	if Drag_Handler.is_changing_rotation: # The BP's rotation is being dragged
		Undo_Redo.create_action("Change binding point rotation by dragging")
		var new_rotation = get_rotation()
		Undo_Redo.add_do_method(func():
			lambda_dict["owner"].set_bp_rotation(new_rotation)
		)
		var start_rotation = Drag_Handler.local_node_start_rotation
		Undo_Redo.add_undo_method(func():
			lambda_dict["owner"].set_bp_rotation(start_rotation)
		)
		Undo_Redo.commit_action()
	else: # The BP's position is being dragged
		Undo_Redo.create_action("Change binding point position by dragging")
		var new_x = get_position().x
		var new_y = get_position().y
		Undo_Redo.add_do_method(func():
			lambda_dict["owner"].set_bp_position(new_x, new_y)
		)
		var start_x = Drag_Handler.local_node_start_pos.x
		var start_y = Drag_Handler.local_node_start_pos.y
		Undo_Redo.add_undo_method(func():
			lambda_dict["owner"].set_bp_position(start_x, start_y)
		)
		Undo_Redo.commit_action()

func end_short_drag_press():
	assert(being_dragged)
	being_dragged = false
	request_to_be_held()

func start_drag():
	assert(not being_dragged)
	being_dragged = true
	update_style()
#endregion


func request_to_be_held():
	Undo_Redo.create_action("Start holding a binding point")
	Event_Bus.request_to_be_held.emit(self)
	Undo_Redo.commit_action()

func start_hold():
	being_held = true
	update_style()

func stop_hold():
	being_held = false
	update_style()


func init(init_dict, create_copy = false, new_real_parent = null):
	assert(typeof(init_dict) == typeof({}))
	
	if not create_copy:
		dict = init_dict
	
	for key in init_dict:
		if key in ["x", "y", "angle"]:
			dict[key] = float(init_dict[key])
		elif create_copy: # If dict = init_dict, this would be a no-op
			dict[key] = init_dict[key]
	
	dict["owner"] = self
	if new_real_parent != null:
		#print("init param")
		set_real_parent(new_real_parent)
	elif "real_parent" in dict:
		#print("init dict")
		set_real_parent(dict["real_parent"])
	
	if "x" in dict and "y" in dict:
		position = Vector2(dict["x"], dict["y"])
	if "angle" in dict:
		rotation_degrees = dict["angle"]
	if "name" in dict:
		bp_name = dict["name"]


func permanent_reparent(new_parent, keep_global_transform = false):
	reparent(new_parent, keep_global_transform)
	set_real_parent(new_parent)

func get_keep_global_transform():
	return true

func set_real_parent(new_real_parent):
	#print("setting to ", new_real_parent)
	real_parent = new_real_parent
	dict["real_parent"] = new_real_parent
func get_real_parent():
	return real_parent
func get_parent_after_placing():
	return real_parent

func set_attribute(key, value):
	dict[key] = value
func get_attribute(key):
	return dict[key]

func get_displayable_attributes():
	return {}

func set_bp_position(x, y):
	position = Vector2(x, y)
	set_attribute("x", x)
	set_attribute("y", y)
	if "xml_node" in dict:
		pass # TODO: keep the XML node up to date (assuming that's necessary)

func get_bp_position():
	return position


func set_bp_rotation(new_rotation):
	set_rotation(new_rotation)
	set_attribute("angle", get_rotation_degrees())
	if "xml_node" in dict:
		pass # TODO: keep the XML node up to date (assuming that's necessary)

func get_bp_rotation():
	return position


func set_editing_mode(enabled):
	if editing_enabled == enabled: return
	editing_enabled = enabled
	if not editing_enabled and being_dragged:
		Drag_Handler.end_drag()
	update_style()


func update_style():
	var hovering = mouse_drag_hovering or mouse_rotation_hovering
	var color_name = "default"
	if editing_enabled:
		color_name = "editable"
		if hovering:
			color_name = "hover_editable"
	elif hovering:
		color_name = "hover"
	$Sprite.modulate = Global_Colors.binding_point[color_name]
	if being_dragged:
		$Sprite.modulate = Color(1, 0, 0)


func _on_tree_exiting():
	if being_dragged:
		Drag_Handler.end_drag()


#region save/restore with a dict
func get_copied_restore_dict():
	var res = {
		"name": bp_name,
		"x": position.x,
		"y": position.y,
		"angle": dict["angle"],
		"owner": dict["owner"],
	}
	if real_parent != null:
		res["real_parent"] = real_parent
	return res

func get_restore_dict():
	return dict

func get_restore_function():
	var lambda_self_scene = self_scene
	var restore_dict = get_restore_dict()
	return func restore_binding_point():
		var res = lambda_self_scene.instantiate()
		res.restore_from_dict(restore_dict)
		return res

func restore_from_dict(restore_dict):
	init(restore_dict)
#endregion
