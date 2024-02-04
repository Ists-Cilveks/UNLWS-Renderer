extends Control

@export var show_button : Button

func _ready():
	show_button.pressed.connect(show_and_signal)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			hide_and_signal()

func _on_close_button_pressed():
	hide_and_signal()

func hide_and_signal():
	hide()
	Event_Bus.overlay_opened.emit()

func show_and_signal():
	show()
	print("asdf")
	$CloseButton.grab_focus.call_deferred()
	Event_Bus.overlay_closed.emit()
