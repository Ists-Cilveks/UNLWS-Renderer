extends Node

var is_dragging = false
var local_mouse_start_pos
var local_node_start_pos
var node

func _input(event):
	if is_dragging:
		if event is InputEventMouseMotion:
			var local_mouse_pos = node.get_parent().to_local(event.get_global_position())
			var canvas_transform = node.get_viewport().get_canvas_transform()
			var mouse_offset = local_mouse_pos - local_mouse_start_pos
			var inverse_canvas_transform = Transform2D(canvas_transform.x, canvas_transform.y, Vector2.ZERO).affine_inverse()
			var node_offset = inverse_canvas_transform * mouse_offset
			var new_position = local_node_start_pos + node_offset
			# TODO: this is a complicated solution, there's probably an easier way to get the position.
			node.update_drag_position(new_position)
		if event is InputEventMouseButton \
			and event.is_released() \
			and event.button_index == MOUSE_BUTTON_LEFT:
			end_drag()

func end_drag():
	node.end_drag()
	is_dragging = false

func start_drag(event, new_node):
	node = new_node
	local_mouse_start_pos = node.get_parent().to_local(event.get_global_position())
	local_node_start_pos = node.get_parent().to_local(node.get_global_position())
	is_dragging = true

# Given an event and a node that can be dragged and is hovered,
# determine if the event should start a drag, and if so, start it.
func check_drag_start(event, check_node):
	if is_dragging: return # Don't drag multiple nodes at once
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_pressed():
			check_node.start_drag()
			Drag_Handler.start_drag(event, check_node)
