extends Control

signal glyph_name_selected(glyph_name, glyphs)
#signal glyph_name_input_cancelled
#signal glyph_name_input_started
#signal glyph_name_input_changed(input, glyphs)


var glyphList = preload("./GlyphList.gd").new()
var glyphs = glyphList.glyphs

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func erase_all_text():
	$GlyphSearchEntry.text = ""

func append_text(str):
	if len($GlyphSearchEntry.text) == 0:
#		glyph_name_input_started.emit()
		show()
	$GlyphSearchEntry.text += str

func backspace_input():
	$GlyphSearchEntry.text = $GlyphSearchEntry.text.left(len($GlyphSearchEntry.text)-1)

func cancel_input():
	erase_all_text()
#	glyph_name_input_cancelled.emit()
	hide()

func input_complete():
	glyph_name_selected.emit($GlyphSearchEntry.text, glyphs)
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



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_glyph_search_entry_glyph_name_input_cancelled():
#	hide()
#
#func _on_glyph_search_entry_glyph_name_input_started():
#	show()
