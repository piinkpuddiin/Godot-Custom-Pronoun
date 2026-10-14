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
	#... we have to use regex good lord...
	var text_array = text.split(".")
	var new_array: Array[String]
	
	for i in text_array:
		var first_letter: String = i.left(1)
		
		# Checks if there is blank space before the first word in the sentence.
		if first_letter == " ":
			first_letter = i.left(2)
			#print("The first letter: /",first_letter,"/")
			i = i.erase(0, 2)
		else:
			i = i.erase(0)
		
		i = first_letter.to_upper() + i
		#print("The sentence: ",i)
		new_array.append(i)
	
	var new_text = ".".join(new_array)
	return new_text


#endregion
