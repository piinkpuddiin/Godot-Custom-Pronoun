@tool
extends DialogicIndexer

func _get_subsystems() -> Array:
	return [{'name':'UppercaseText', 'script':this_folder.path_join('subsystem_uppercase_text.gd')}]