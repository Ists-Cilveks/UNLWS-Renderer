extends Node

var glyph_type

var line_color = "#ff00ff"

func set_style(color="#000000"):
	line_color = color



func _init(init_glyph_type):
	#var file = FileAccess.open(svg_path, FileAccess.READ)
	#var content = file.get_as_text()
	#var all_paths = get_paths_from_svg(content)
	glyph_type = init_glyph_type
	var all_paths = glyph_type.all_paths
	# From https://www.reddit.com/r/godot/comments/iban3j/comment/g1uwybu/ by https://www.reddit.com/user/bippinbits/
	var selected_path = all_paths[0]
	var l := Line2D.new()
	l.default_color = Color(1,1,1,1)
	l.width = 20
	for point in selected_path.curve.get_baked_points():
		l.add_point(point + selected_path.position)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
