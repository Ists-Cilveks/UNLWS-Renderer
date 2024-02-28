extends GridContainer

func _ready():
	Event_Bus.started_holding_glyphs.connect(update_children)
	Event_Bus.stopped_holding_glyphs.connect(update_children)
	Event_Bus.started_selecting_glyphs.connect(update_children)
	Event_Bus.stopped_selecting_glyphs.connect(update_children)

func update_children(children = null):
	if children != null and len(children) == 1:
		var instance = children[0]
		$GlyphAttributes.update(instance)
		$BindingPointInfo.update(instance)
		$FileData/PathLineEdit.update(instance)
		show()
	else:
		hide()
