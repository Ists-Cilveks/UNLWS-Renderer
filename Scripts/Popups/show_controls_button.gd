extends Button

var controls_info_scene = preload("../Popups/controls_info.tscn")

func _ready():
	Event_Bus.add_popup_signal.emit(pressed, controls_info_scene)
