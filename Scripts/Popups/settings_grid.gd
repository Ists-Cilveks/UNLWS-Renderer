extends GridContainer

func _ready():
	var all_settings = [
		{
			"section_name": "glyph editing",
			"settings": [
				["allow_editing_multiple_glyphs", "Allow editing multiple glyphs at once"],
			]
		},
		{
			"section_name": "text creation",
			"settings": [
				["deselect_glyphs_after_placing", "Deselect glyphs as soon as they are placed"],
			]
		},
	]
	
	for section in all_settings:
		var section_name = section["section_name"]
		for setting in section["settings"]:
			var setting_name = setting[0]
			var setting_label_text = setting[1]
			var get_new_value = func get_new_value():
				return Settings_Handler.get_setting(section_name, setting_name)
			var set_new_value = func set_new_value(new_value):
				Settings_Handler.set_setting(section_name, setting_name, new_value)
				Settings_Handler.save_settings()
			var row = Grid_Row_With_Check_Button.new(
				self,
				setting_name,
				setting_label_text,
				get_new_value,
				set_new_value
				)
			row.update_pressed()
			row.add_to_grid(self)
