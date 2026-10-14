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
	var text_array: Array[String]
	var new_text: String = ""
	print("the og:", text)
	
	# Strip the bbcode from the string. 
	# https://github.com/godotengine/godot-proposals/issues/5056
	#var regex = RegEx.new()
	#regex.compile("\\[.+?\\]")
	#text = regex.sub(text, "", true)
	#print("parsed text...: ", text)
	
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
		# We're adding the bbcode for visuals here.
		#if i.contains(P.their):
			#var i_pos = i.find(P.their)
			#i = i.insert(i_pos,'[color=pink]')
			#i = i.insert(i_pos + P.their.length() + len('[color=pink]'), '[/color]')
		#if i.contains(P.they):
			#var i_pos = i.find(P.they)
			#i = i.insert(i_pos,'[color=black]')
			#i = i.insert(i_pos + P.they.length() + len('[color=black]'), '[/color]')
		
		new_text += i
	
	print(new_text)
	return new_text


#endregion
