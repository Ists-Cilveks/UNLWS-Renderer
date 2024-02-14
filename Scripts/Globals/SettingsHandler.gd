extends Node

var settings = ConfigFile.new()
var user_settings_folder_path = "user://Settings/"
var default_settings_path = "res://Scripts/Globals/default_settings.cfg"

func _ready():
	#var error = settings.load("./default_settings.cfg")
	var default_settings_error = settings.load(default_settings_path)
	if default_settings_error != OK: return
	
	# Allowed to fail (file may be deleted)
	settings.load(user_settings_folder_path+"settings.cfg")
	
	print(get_setting("glyph editing", "allow_editing_multiple_glyphs"))

func save_settings():
	DirAccess.make_dir_absolute(user_settings_folder_path)
	var error = settings.save(user_settings_folder_path+"settings.cfg")
	if error != OK:
		assert(false)
		return

func get_setting(section, setting_name):
	return settings.get_value(section, setting_name)

func set_setting(section, setting_name, value):
	settings.set_value(section, setting_name, value)
