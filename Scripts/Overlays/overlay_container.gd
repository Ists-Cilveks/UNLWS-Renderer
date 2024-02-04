extends SubViewportContainer

func _ready():
	Event_Bus.overlay_opened.connect(show)
	Event_Bus.overlay_closed.connect(hide)

func _on_resized():
	$OverlayViewport.size = size
