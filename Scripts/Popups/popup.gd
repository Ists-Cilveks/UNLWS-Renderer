extends Control

func _ready():
	Focus_Handler.push($CloseButton)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("ui_cancel"):
			remove()

func _on_close_button_pressed():
	remove()

func remove():
	Event_Bus.popup_closing.emit(self)
	Focus_Handler.pop()
