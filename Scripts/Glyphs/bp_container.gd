extends Node2D

var binding_point_scene = preload("./binding_point.tscn")

func set_visibility(enabled):
	if enabled:
		show()
	else:
		hide()

func set_editing_mode(enabled):
	for child in get_children():
		child.set_editing_mode(enabled)


func get_bp_restore_dicts():
	var res = []
	for bp in get_children():
		res.append(bp.get_restore_dict())
	return res

func restore_bps_from_dicts(all_dicts):
	for dict in all_dicts:
		var bp = binding_point_scene.instantiate()
		bp.init(dict)
		add_child(bp)

func restore_bps_from_glyph_type(glyph_type):
	for name_of_bp_to_copy in glyph_type.binding_points:
		var new_bp = binding_point_scene.instantiate()
		new_bp.init(glyph_type.binding_points[name_of_bp_to_copy].dict)
		add_child(new_bp)
