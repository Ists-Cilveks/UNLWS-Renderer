extends Node2D

var holding_glyph = false

func _ready():
	Event_Bus.glyph_search_succeeded.connect(hold_instance)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if holding_glyph:
				place_held_glyphs()

func place_held_glyphs():
	$SelectedGlyphs.place($Glyphs)
	holding_glyph = false
	Event_Bus.stopped_holding_glyphs.emit()

#func set_by_name(glyph_name):
	#$SelectedGlyphs.set_by_name(glyph_name)
	#holding_glyph = true
	#Event_Bus.started_holding_glyphs.emit()

func hold_instance(new_instance):
	$SelectedGlyphs.overwrite(new_instance)
	holding_glyph = true
	Event_Bus.started_holding_glyphs.emit()
