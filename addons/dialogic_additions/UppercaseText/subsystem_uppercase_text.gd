extends DialogicSubsystem

## Describe the subsystems purpose here.

const TAG_REGEX = "\\[(?<tag>.*?)\\]"

# The tag regex object
var tag_regex = RegEx.create_from_string(TAG_REGEX)
#region STATE
####################################################################################################

func _clear_state(clear_flag:=Dialogic.ClearFlags.FULL_CLEAR) -> void:
	pass

func _load_state(load_flag:=LoadFlags.FULL_LOAD) -> void:
	pass

#endregion


#region MAIN METHODS
####################################################################################################

# TODO: i know what this entails but yeah im popped... see you tmrw 🫡
func modifier_uppercase_text(text: String) -> String:
	var rtl: RichTextLabel
	rtl.text = text
	# Get all the matches in the text
	var matches = tag_regex.search_all(text)
	var last = 0
	# For each match
	for _match in matches:
		# Get the start and end indices of the match
		var start = _match.get_start(0)
		var end = _match.get_end(0)
		
		# Get the tag group and parse it with the built-in method
		var tag = _match.get_string("tag")
		var expr = rtl.parse_expressions_for_values([tag])
		var has_uppercase = expr.has("ucase")
	return text

#endregion
