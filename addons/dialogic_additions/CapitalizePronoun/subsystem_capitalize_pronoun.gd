extends DialogicSubsystem

## Checks where the pronouns are. If at the start of the sentence or
## in front of a period, capitalize.

#region STATE
####################################################################################################

func _clear_state(clear_flag:=Dialogic.ClearFlags.FULL_CLEAR) -> void:
	pass

func _load_state(load_flag:=LoadFlags.FULL_LOAD) -> void:
	pass

#endregion


#region MAIN METHODS
####################################################################################################

func modifier_capitalize_pronoun(text: String) -> String:
	#... we HAVE to use regex good lord...
	var new_array: Array[String]
	var new_text: String = ""
	
	var r:= RegEx.new()
	#r.compile("\\s*[!?\\.]\\s*")
	r.compile("([^\\.!?]*[\\.!?])")
	
	for i in r.search_all(text):
		#print("'", i.get_string(), "'")
		var r_string: String = i.get_string()
		var first_letter: String
		
		if r_string[0] == " ":
			first_letter = r_string[1]
			r_string = r_string.erase(0,2)
			r_string = " " + first_letter.to_upper() + r_string
			
			#print("the first letter", first_letter.to_upper())
			#print("deleted first letter", r_string)
		else:
			first_letter = r_string[0]
			r_string = r_string.erase(0)
			r_string = first_letter.to_upper() + r_string
		
		new_array.append(r_string)
		print("The r_string: ", r_string)
	
	for i in new_array:
		new_text += i
	
	return new_text


#endregion
