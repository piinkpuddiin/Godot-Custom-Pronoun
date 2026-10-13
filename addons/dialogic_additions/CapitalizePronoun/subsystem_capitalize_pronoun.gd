extends DialogicSubsystem

## Describe the subsystems purpose here.


#region STATE
####################################################################################################

func _clear_state(clear_flag:=Dialogic.ClearFlags.FULL_CLEAR) -> void:
	pass

func _load_state(load_flag:=LoadFlags.FULL_LOAD) -> void:
	pass

#endregion


#region MAIN METHODS
####################################################################################################

# TODO: Check where the pronouns are. If at the start of the sentence or
# in front of a period, capitalize.
# TODO: for some reason the second sentence wants to be a bitch...
func modifier_capitalize_pronoun(text: String) -> String:
	var text_array = text.split(".")
	var new_array: Array[String]
	
	for i in text_array:
		var first_letter: String
		
		first_letter = i.left(1)
		
		if first_letter == " ":
			#first_letter = first_letter.replace(" ", "")
			first_letter = i.left(2)
			if first_letter.contains(" "):
				first_letter = first_letter.erase(0)
			print("The first letter: /",first_letter,"/")
			i = i.erase(0, 2)
		else:
			i = i.erase(0)
		
		i = first_letter.to_upper() + i
		print("first letter:", first_letter)
		print("upper i: ", i)
		new_array.append(i)
	
	var new_text = ".".join(new_array)
	return new_text


#endregion
