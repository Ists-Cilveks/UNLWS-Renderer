extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var old_pos = position
#	var lagged_target_pos = get_viewport().get_mouse_position()
#	position = lagged_target_pos + (lagged_target_pos - old_pos)*0.5
	position = get_viewport().get_mouse_position()
