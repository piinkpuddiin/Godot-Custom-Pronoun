@tool
extends DialogicIndexer

func _get_subsystems() -> Array:
	return [{'name':'CapitalizePronoun', 'script':this_folder.path_join('subsystem_capitalize_pronoun.gd')}]

func _get_text_modifiers() -> Array[Dictionary]:
	return [
		{
			"subsystem":"CapitalizePronoun", 
			"method":"modifier_capitalize_pronoun", 
			"mode": -1
		}, #-1 = Text&Choice, 0 = TextsOnly, 1 = ChoicesOnly
	]
