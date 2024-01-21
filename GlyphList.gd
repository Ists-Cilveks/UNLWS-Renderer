extends Object

var Glyph = preload("GlyphType.gd")
var glyphs = {}

# Modified from https://gist.github.com/Sirosky/a60ae50a78a420bd9eaaff430a78fbcf
func get_all_files(path: String, file_ext := "", files := []) -> Array: #Loops through an entire directory recursively, and pulls the full file paths
	var dir = DirAccess.open(path)

	if dir != null:
		dir.list_dir_begin()

		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				files = get_all_files(dir.get_current_dir() + "/" + file_name, file_ext, files)
			else:
				if not file_ext is String or len(file_ext) == 0 or file_name.get_extension() == file_ext:
					files.append(dir.get_current_dir() + "/" + file_name)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s." % path)

	return files

func get_filename_from_path(path):
	return path.rsplit("/", true, 1)[1].rsplit(".", true, 1)[0]

func _init():
	var svg_paths = get_all_files("res://Images/Glyphs/", "svg")
	
	for path in svg_paths:
		var glyph_name = get_filename_from_path(path)
		glyphs[glyph_name] = Glyph.new(path)

#var glyphs = {
#	"eat": Glyph.new("res://Images/Glyphs/eat.svg"),
#	"cat": Glyph.new("res://Images/Glyphs/cat.svg"),
#	}
