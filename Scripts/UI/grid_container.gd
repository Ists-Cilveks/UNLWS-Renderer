extends GridContainer

func _ready():
	get_children()[0].grab_focus.call_deferred()
