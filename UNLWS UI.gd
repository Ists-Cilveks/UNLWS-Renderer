extends Control

signal glyph_list_set(glyph_list)

var glyphs = Glyph_List.new().glyphs

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	glyph_list_set.emit(glyphs)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


