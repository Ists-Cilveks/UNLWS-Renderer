extends Node

var is_dragging = false
var node_start_pos
var mouse_start_pos
var node

func _input(event):
	if is_dragging:
		if event is InputEventMouseMotion:
			print("event.position ", event.position)
			#print("get_local_mouse_position() ", get_local_mouse_position())
			#print("get_global_mouse_position() ", get_global_mouse_position())
			print("event.get_global_position() ", event.get_global_position())
			print("node_start_pos ", node_start_pos)
			print("node.to_local(event.position) ", node.to_local(event.position))
			print("mouse_start_pos ", mouse_start_pos)
			print()
			#var new_position = node_start_pos + node.to_local(event.position) - mouse_start_pos
			#var new_position = node_start_pos
			var new_position = node_start_pos + event.get_global_position() - mouse_start_pos
			#node.update_drag_position(new_position)
			node.update_drag_position(node.get_parent().to_local(new_position))
		elif event is InputEventMouseButton \
			and event.is_released() \
			and event.button_index == MOUSE_BUTTON_LEFT:
			end_drag()

func end_drag():
	node.end_drag()
	is_dragging = false
	print("end")

func start_drag(new_node, event):
	node = new_node
	mouse_start_pos = event.get_global_position()
	node_start_pos = node.get_global_position()
	is_dragging = true
