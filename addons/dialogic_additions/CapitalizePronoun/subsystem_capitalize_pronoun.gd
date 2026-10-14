extends DialogicSubsystem

## Capitalizes every first word of each sentence. If at the start of the sentence or
## in front of a period, capitalize. And makes sure the bbcode is still in place.

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
	var text_array: Array[String]
	var bbcode_dict: Dictionary
	var bbcode_array: Array
	var new_text: String = ""
	
	# Strip the bbcode from the string. 
	# https://github.com/godotengine/godot-proposals/issues/5056
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	# Store the bbcodes and their index in the dict.
	for i in regex.search_all(text):
		var bbcode = i.get_start()
		bbcode_dict[bbcode] = i.get_string()
	#print("bbcode dict: ", bbcode_dict)
	
	# We remove the bbcode from the text.
	text = regex.sub(text, "", true)
	
	var r:= RegEx.new()
	# RedEx: This is a capturing group, it will begin with the start of the sentence and look 
	# for any of the punctuations to close the group. Matches the literal punctuations as well. 
	# (To re-explain/comment later)
	r.compile("([^\\.!?]*[\\.!?])")
	
	for i in r.search_all(text):
		var r_string: String = i.get_string()
		var first_letter: String
		
		# Usually any sentence after the first one. Looks to see if there 
		# is empty space in the beginning of the sentence.
		if r_string[0] == " ":
			first_letter = r_string[1]
			# Erase both the white space and the first letter.
			r_string = r_string.erase(0,2)
			# Add the white space back in.
			r_string = " " + first_letter.to_upper() + r_string
		# The first sentence.
		else:
			first_letter = r_string[0]
			r_string = r_string.erase(0)
			r_string = first_letter.to_upper() + r_string
		
		text_array.append(r_string)
		#print("The r_string: ", r_string)
	
	# Create the new sentence.
	for i in text_array:
		new_text += i
	
	# We add the bbcode back.
	for i in bbcode_dict.keys():
		new_text = new_text.insert(i, bbcode_dict[i])
	
	print(new_text)
	return new_text


#endregion
