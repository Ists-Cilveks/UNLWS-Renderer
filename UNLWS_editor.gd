extends Control

var glyphs = Glyph_List.glyphs

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var test_text = UNLWS_Text.new()
	test_text.add_glyph(Glyph_Instance.new(glyphs["cat"]))
	test_text.add_glyph(Glyph_Instance.new(glyphs["eat"], Vector2(10, 0), 20)) # TODO: rotation's broken
	var xml_string = test_text.xml_node.get_string()
	var test_file = FileAccess.open("res://Images/Output/text.svg", FileAccess.WRITE)
	test_file.store_string(xml_string)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


