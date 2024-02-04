extends Control

var glyph_instance_scene = load("res://Scripts/Glyphs/glyph_instance.tscn")
var glyphs = Glyph_List.glyphs
var test_instance = glyph_instance_scene.instantiate()

func erase_all_text():
	$GlyphSearchEntry.text = ""

func append_text(text):
	if len($GlyphSearchEntry.text) == 0:
#		glyph_name_input_started.emit()
		show()
	$GlyphSearchEntry.text += text

func backspace_input():
	$GlyphSearchEntry.text = $GlyphSearchEntry.text.left(len($GlyphSearchEntry.text)-1)

func cancel_input():
	var key_handled = false
	if len($GlyphSearchEntry.text) != 0:
		key_handled = true
	erase_all_text()
#	glyph_name_input_cancelled.emit()
	hide()
	return key_handled

func input_complete():
	var glyph_name = $GlyphSearchEntry.text
	var key_handled = false
	if glyph_name:
		key_handled = true
	if glyph_name in glyphs:
		Undo_Redo.create_action("Overwrite held glyph with search")
		var glyph_type = glyphs[glyph_name]
		var instance = glyph_instance_scene.instantiate()
		instance.init(glyph_type)
		Event_Bus.glyph_search_succeeded.emit(instance)
		Undo_Redo.commit_action()
	cancel_input()
	return key_handled

func _input(event):
#	var glyph_input_box = $"GlyphSearch/SearchEntry"
#	var glyph_input_box = self
	var key_handled = false
	if event.is_action_pressed("ui_text_backspace_all_to_left.macos"):
		erase_all_text()
		key_handled = true
	elif event.is_action_pressed("ui_cancel"):
		key_handled = cancel_input()
	elif event.is_action_pressed("ui_text_backspace"):
		backspace_input()
		key_handled = true
	elif event.is_action_pressed("ui_accept"):
#			$"Mouse/HeldGlyph".change_glyph(self, $GlyphSearchEntry.text)
		key_handled = input_complete()
	elif event is InputEventKey and event.pressed:
		var key = String.chr(event.unicode).to_lower()
		if not event.meta_pressed and len(key) == 1:
			append_text(key)
			key_handled = true
	
	if key_handled:
		# Prevents buttons from being pressed by enter or space if the gui buttons are focused
		accept_event()
