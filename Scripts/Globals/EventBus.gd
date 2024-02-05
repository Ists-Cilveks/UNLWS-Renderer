extends Node
## A singleton that contains signals about global events like inputs

signal glyph_placed(glyph)
signal glyph_search_succeeded(glyph_instance)

signal started_holding_glyphs()
signal stopped_holding_glyphs()

signal popup_opened(popup)
signal popup_closing(popup)

signal search_halted()
signal search_resumed()
