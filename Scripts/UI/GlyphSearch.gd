extends Control

var glyph_instance_scene = load("res://Scripts/Glyphs/glyph_instance.tscn")
var glyphs = Glyph_List.glyphs

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
	erase_all_text()
#	glyph_name_input_cancelled.emit()
	hide()

func input_complete():
	var glyph_name = $GlyphSearchEntry.text
	if glyph_name in glyphs:
		var glyph_type = glyphs[glyph_name]
		var instance = glyph_instance_scene.instantiate()
		instance.init(glyph_type)
		Event_Bus.glyph_search_succeeded.emit(instance)
	cancel_input()

func _input(event):
#	var glyph_input_box = $"GlyphSearch/SearchEntry"
#	var glyph_input_box = self
	if event is InputEventKey and event.pressed:
#		print(event.as_text())
		if event.is_action_pressed("ui_text_backspace_all_to_left"):
			erase_all_text()
		elif event.is_action_pressed("ui_cancel"):
			cancel_input()
		elif event.is_action_pressed("ui_text_backspace"):
			backspace_input()
		elif event.is_action_pressed("ui_accept"):
#			$"Mouse/HeldGlyph".change_glyph(self, $GlyphSearchEntry.text)
			input_complete()
		else:
#			var key = OS.get_keycode_string(event.keycode).to_lower()
#			var key = OS.get_keycode_string(event.unicode).to_lower()
			var key = String.chr(event.unicode).to_lower()
#			print(key)
			if not event.ctrl_pressed and len(key) == 1:
				
	#			$"GlyphSearch/SearchEntry".grab_focus()
	#			print(event.as_text())
				append_text(key)
