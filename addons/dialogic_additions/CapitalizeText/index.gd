@tool
extends DialogicIndexer

func _get_subsystems() -> Array:
	return [{'name':'CapitalizeText', 'script':this_folder.path_join('subsystem_capitalize_text.gd')}]