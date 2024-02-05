extends Button

var glyph_editor_scene = preload("./glyph_editor.tscn")

func _ready():
	Event_Bus.add_popup_signal.emit(pressed, glyph_editor_scene)
