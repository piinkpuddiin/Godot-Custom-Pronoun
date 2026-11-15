@tool
extends RichTextEffect
class_name RichTextUppercase

# Define the tag name.
var bbcode = "ucase"

# Gets TextServer for retrieving font information.
func get_text_server():
	return TextServerManager.get_primary_interface()

func _process_custom_fx(char_fx):
	var value = char_fx.glyph_index
	if !value == 0:
		var char_upper = char(get_text_server().font_get_char_from_glyph_index(char_fx.font, 1, value)).to_upper()
		char_fx.glyph_index = get_text_server().font_get_glyph_index(char_fx.font, 1, char_upper.unicode_at(0), 0)
	return true
