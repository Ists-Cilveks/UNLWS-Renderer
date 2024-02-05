extends Node

var glyphs = Glyph_List.glyphs

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: this isn't a great place to create the necessary empty folders.
	var res_dir = DirAccess.open("res://")
	res_dir.make_dir("Output")
	res_dir.make_dir("Input")
	
	# Define binding points
	#glyphs["eat"].set_bp_info("A", Vector2(20.8-20.299457, 26.4-17.823843), 180)
	#glyphs["eat"].set_bp_info("B", Vector2(27.8-20.299457, 30.4-17.823843), 90)
	#glyphs["cat"].set_bp_info("X", Vector2(31.85-15.725407, 26.25-15.184546), 0)
	#glyphs["perceive"].set_bp_info("X", Vector2(11, 11), 0)
	#glyphs["perceive"].set_bp_info("S", Vector2(0.5, 0.2), 0)
	
	# Create a test text and add new glyph instances to it.
	var test_text = UNLWS_Text.new()
	# The format: Glyph_Instance.new(*glyph*, *name/id*, *position*, *angle*)
	# *position* is the position of the binding point (in pixels)
	# *angle* is the angle (clockwise from the x axis, in degrees) in which the BP line stub points
	test_text.add_glyph(Glyph_Instance.new(glyphs["cat"], "X", Vector2(20, 15), 0))
	test_text.add_glyph(Glyph_Instance.new(glyphs["eat"], "B", Vector2(20, 15), 180))
	test_text.add_glyph(Glyph_Instance.new(glyphs["amused"], "X", Vector2(50, 20), 270))
	test_text.add_glyph(Glyph_Instance.new(glyphs["eat"], "A", Vector2(50, 20), 90))

	var xml_string = test_text.xml_node.get_string()
	var test_file = FileAccess.open("res://Output/text.svg", FileAccess.WRITE)
	test_file.store_string(xml_string)
	
	Glyph_List.save_all_to_folder("res://Images/Glyphs/")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


