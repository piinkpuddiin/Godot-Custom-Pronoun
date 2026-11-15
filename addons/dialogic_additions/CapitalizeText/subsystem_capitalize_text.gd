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

func modifier_capitalize_text(text: String) -> String:
	print("Capitalize text...", text)
	return text

#endregion
