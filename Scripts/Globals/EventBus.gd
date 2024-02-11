extends Node
## A singleton that contains signals about global events like inputs

signal glyph_placed(glyph)
signal glyph_search_succeeded(glyph_instance)

signal started_holding_glyphs(children)
signal stopped_holding_glyphs()

signal started_selecting_glyphs(children)
signal stopped_selecting_glyphs()

signal popup_opened(popup)
signal popup_closing(popup)

signal search_halted()
signal search_resumed()

signal add_popup_signal(activation_signal, popup_scene)

signal glyph_selection_attempted(glyph_instance, if_successful)
signal glyph_extra_selection_attempted(glyph_instance, if_successful)
