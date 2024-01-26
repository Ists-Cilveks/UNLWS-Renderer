extends Control

var glyphs = Glyph_List.glyphs

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var test_text = UNLWS_Text.new()
	
	#glyphs["eat"].set_bp_info("A", Vector2(20.8, 26.4), 180)
	#glyphs["eat"].set_bp_info("B", Vector2(27.8, 30.4), 270)
	#glyphs["cat"].set_bp_info("X", Vector2(31.85, 26.25), 0)
	
	test_text.add_glyph(Glyph_Instance.new(glyphs["cat"]))
	test_text.add_glyph(Glyph_Instance.new(glyphs["eat"], Vector2(10, 0), 0, "A"))

	var xml_string = test_text.xml_node.get_string()
	var test_file = FileAccess.open("res://Output/text.svg", FileAccess.WRITE)
	test_file.store_string(xml_string)
	
	Glyph_List.save_all_to_folder("res://Images/Glyphs/")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


